import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:pawprints/services/auth.service.dart';

import '../models/pets/pets.dart';
import 'product.service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const PET_COLLECTION = "pets";

class PetService {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  PetService({
    FirebaseFirestore? firebaseFirestore,
    FirebaseAuth? firebaseAuth,
    FirebaseStorage? firebaseStorage,
  })  : firestore = firebaseFirestore ?? FirebaseFirestore.instance,
        auth = firebaseAuth ?? FirebaseAuth.instance,
        storage = firebaseStorage ?? FirebaseStorage.instance;
  Future<void> createPet(Pet pet, File? imageFile) async {
    final String uid = auth.currentUser?.uid ?? "";

    String? imageUrl;

    // Upload the image if it exists
    if (imageFile != null) {
      // Generate a unique name for the image
      String fileName = '${pet.id}.jpg';
      try {
        // Upload the image to Firebase Storage
        TaskSnapshot snapshot =
            await storage.ref().child('pets/$uid/$fileName').putFile(imageFile);

        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        // Log the error and handle it gracefully
        print('Error uploading image: $e');
        // You can choose to return early or set imageUrl to null
      }
    }

    // Set the image URL on the pet object
    pet.image = imageUrl ?? "";

    // Save the pet information to Firestore
    try {
      await firestore
          .collection(USERS_COLLECTION)
          .doc(uid)
          .collection(PET_COLLECTION)
          .doc(pet.id)
          .set(pet.toJson());
      print('Pet created successfully: ${pet.toJson()}');
    } catch (e) {
      print('Error saving pet data: $e');
    }
  }

  // Read a pet by ID
  Future<Pet?> readPet(String petId) async {
    final String uid = auth.currentUser?.uid ?? "";

    DocumentSnapshot doc = await firestore
        .collection(USERS_COLLECTION)
        .doc(uid)
        .collection(PET_COLLECTION)
        .doc(petId)
        .get();

    if (doc.exists) {
      return Pet.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null; // Pet not found
  }

  // Update an existing pet
  Future<void> updatePet(Pet pet) async {
    final String uid = auth.currentUser?.uid ?? "";

    return firestore
        .collection(USERS_COLLECTION)
        .doc(uid)
        .collection(PET_COLLECTION)
        .doc(pet.id)
        .update(pet.toJson());
  }

  // Delete a pet by ID
  Future<void> deletePet(String petId) async {
    final String uid = auth.currentUser?.uid ?? "";

    return firestore
        .collection(USERS_COLLECTION)
        .doc(uid)
        .collection(PET_COLLECTION)
        .doc(petId)
        .delete();
  }

  // Fetch all pets for the current user
  Future<List<Pet>> getAllPets() async {
    final String uid = auth.currentUser?.uid ?? "";
    QuerySnapshot snapshot = await firestore
        .collection(USERS_COLLECTION)
        .doc(uid)
        .collection(PET_COLLECTION)
        .get();

    return snapshot.docs.map((doc) {
      return Pet.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
