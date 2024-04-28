// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// ignore_for_file: constant_identifier_names

enum Banks {
  ABSA,
  Capitec,
  FNB,
  Nedbank,
  StandardBank,
  Investec,
  AfricanBank,
  Tymebank,
  BidvestBankGrow
}

@override
String toString(Banks bank) {
  switch (bank) {
    case Banks.ABSA:
      return "3284A0AD-BA78-4838-8C2B-102981286A2B";
    case Banks.Capitec:
      return "913999FA-3A32-4E3D-82F0-A1DF7E9E4F7B";
    case Banks.FNB:
      return "4816019C-3314-4C80-8B6B-B2CD16DCC4EC";
    case Banks.Nedbank:
      return "D3889DF6-CDAC-4861-9D64-2B100FB7ED07";
    case Banks.StandardBank:
      return "AD8127C6-316D-459C-ADCC-E62A214251FC";
    case Banks.Investec:
      return "4B45BE85-B616-4BD1-9027-F8FCF8F9AF7B";
    case Banks.AfricanBank:
      return "33A0840B-0CF4-4B8C-86E0-EC6C4BE8C60E";
    case Banks.Tymebank:
      return "28FCC8FA-985B-480B-82FD-7D09BC19C9D0";
    case Banks.BidvestBankGrow:
      return "E022DFC8-FF4A-4425-A074-C65D07E8F09C";
  }
}
