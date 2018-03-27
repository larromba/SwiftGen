//
//  DataModel.swift
//  SwiftGenKit
//
//  Created by David Jennes on 19/03/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna

final class DataModel {
  struct Attribute {
    let name: String
    let type: String
    let customClass: String
    let isOptional: Bool
    let isScalar: Bool
    let userInfo: [String: String]
  }

  final class FetchedProperty {
    let name: String
    let predicate: String
    let userInfo: [String: String]
    weak var entity: Entity?
    private let entityName: String

    weak var model: DataModel? = nil {
      didSet {
        entity = model?.entities[entityName]
      }
    }

    init(name: String, predicate: String, entity: String, userInfo: [String: String]) {
      self.name = name
      self.predicate = predicate
      self.entityName = entity
      self.userInfo = userInfo
    }
  }

  final class Relationship {
    let name: String
    let inverseName: String
    let isOptional: Bool
    let isOrdered: Bool
    let toMany: Bool
    let userInfo: [String: String]
    weak var destination: Entity?
    private let destinationName: String

    weak var model: DataModel? = nil {
      didSet {
        destination = model?.entities[destinationName]
      }
    }

    init(name: String, inverseName: String, isOptional: Bool, isOrdered: Bool, toMany: Bool, destination: String, userInfo: [String: String]) {
      self.name = name
      self.inverseName = inverseName
      self.isOptional = isOptional
      self.isOrdered = isOrdered
      self.toMany = toMany
      self.destinationName = destination
      self.userInfo = userInfo
    }
  }

  final class Entity {
    let name: String
    let className: String
    let isAbstract: Bool
    let userInfo: [String: String]
    let attributes: [Attribute]
    let fetchedProperties: [FetchedProperty]
    let relationships: [Relationship]
    weak var parent: Entity?
    private let parentName: String?

    weak var model: DataModel? = nil {
      didSet {
        parent = model?.entities[parentName ?? ""]
        fetchedProperties.forEach { $0.model = model }
        relationships.forEach { $0.model = model }
      }
    }

    init(name: String, className: String, isAbstract: Bool, parent: String?, attributes: [Attribute], fetchedProperties: [FetchedProperty], relationships: [Relationship], userInfo: [String: String]) {
      self.name = name
      self.className = className
      self.isAbstract = isAbstract
      self.parentName = parent
      self.attributes = attributes
      self.fetchedProperties = fetchedProperties
      self.relationships = relationships
      self.userInfo = userInfo
    }
  }

  let name: String
  let entities: [String: Entity]

  init(name: String, entities: [Entity]) {
    self.name = name
    self.entities = Dictionary(uniqueKeysWithValues: entities.map { ($0.name, $0) })
  }
}
