Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:24491 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbXJKJxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 05:53:11 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: remove documentation about EEPROM dump
Date: Thu, 11 Oct 2007 11:53:29 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710111153.29974.hs4233@mail.mn-solutions.de> (sfid-20071011_105317_146681_258853BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver doesn't support dumping of the EEPROM, so this patch
removes the documentation.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/README
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/README	2007-10-11 12:14:50.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/libertas/README	2007-10-11 12:44:59.000000000 +0200
@@ -41,22 +41,6 @@ version: COMM-USB8388-318.p4
 firmware-version: 5.110.7
 bus-info:
 
-Use the -e option to read the EEPROM contents of the card.
-
-	Usage:
-	ethtool -e ethX [raw on|off] [offset N] [length N]
-
-       -e     retrieves and prints an EEPROM dump for the  specified  ethernet
-              device.   When raw is enabled, then it dumps the raw EEPROM data
-              to stdout. The length and offset parameters allow  dumping  cer-
-              tain portions of the EEPROM.  Default is to dump the entire EEP-
-              ROM.
-
-# ethtool -e eth0 offset 0 length 16
-Offset          Values
-------          ------
-0x0000          38 33 30 58 00 00 34 f4 00 00 10 00 00 c4 17 00
-
 ========================
 DEBUGFS COMMANDS
 ========================
