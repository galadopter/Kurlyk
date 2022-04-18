//
//  Effect+Async.swift
//  Kurlyk
//
//  Created by Yan Schneider on 26.11.21.
//

import ComposableArchitecture
import Combine

extension Effect {
    
    /// Creates an `Effect` from non-failing async task.
    ///
    /// It could be cancelled during execution.
    ///
    /// - Parameter priority: Task's priority
    /// - Parameter operation: Non-failing asynchronous operation
    public static func task(
      priority: TaskPriority? = nil,
      operation: @escaping @Sendable () async -> Output
    ) -> Self where Failure == Never {
      var task: Task<Void, Never>?
      return .future { callback in
        task = Task(priority: priority) {
          guard !Task.isCancelled else { return }
          let output = await operation()
          guard !Task.isCancelled else { return }
          callback(.success(output))
        }
      }
      .handleEvents(receiveCancel: { task?.cancel() })
      .eraseToEffect()
    }

    /// Creates an `Effect` from async task. This task can fail and raise an error.
    ///
    /// It could be cancelled during execution.
    ///
    /// - Parameter priority: Task's priority
    /// - Parameter operation: Asynchronous operation
    public static func task(
      priority: TaskPriority? = nil,
      operation: @escaping @Sendable () async throws -> Output
    ) -> Self where Failure: Error {
      Deferred<Publishers.HandleEvents<PassthroughSubject<Output, Failure>>> {
        let subject = PassthroughSubject<Output, Failure>()
        let task = Task(priority: priority) {
          do {
            try Task.checkCancellation()
            let output = try await operation()
            try Task.checkCancellation()
            subject.send(output)
            subject.send(completion: .finished)
          } catch is CancellationError {
            subject.send(completion: .finished)
          } catch let error as Failure {
            subject.send(completion: .failure(error))
          } catch {
              fatalError("Should only contain error of defined type")
          }
        }
        return subject.handleEvents(receiveCancel: task.cancel)
      }
      .eraseToEffect()
    }
}
