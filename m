Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gauss.credativ.com ([93.94.130.89]:40957 "EHLO
        gauss.credativ.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbeEQP3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 11:29:44 -0400
From: Sedat Dilek <sedat.dilek@credativ.de>
To: Luciano Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@credativ.de>
Subject: [PATCH] WHENCE: Fix typo Version v3
Date: Thu, 17 May 2018 17:20:11 +0200
Message-Id: <20180517152011.10322-1-sedat.dilek@credativ.de> (sfid-20180517_172950_022478_01EBA7C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have seen that in the WHENCE file there is "Version" with and
without ":", mostly iwlwifi ucodes.

As an example:

 File: iwlwifi-8265-36.ucode
-Version 36.e91976c0.0
+Version: 36.e91976c0.0

The usual case is "Version:".

This patch is against iwlwifi.git#linux-firmware.

Signed-off-by: Sedat Dilek <sedat.dilek@credativ.de>
---
 WHENCE | 56 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/WHENCE b/WHENCE
index fe63439b8cad..3678bc41a0f0 100644
--- a/WHENCE
+++ b/WHENCE
@@ -866,10 +866,10 @@ File: iwlwifi-7260-13.ucode
 Version: 25.30.13.0
 
 File: iwlwifi-7260-16.ucode
-Version 16.242414.0
+Version: 16.242414.0
 
 File: iwlwifi-7260-17.ucode
-Version 17.bfb58538.0
+Version: 17.bfb58538.0
 
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0
@@ -890,10 +890,10 @@ File: iwlwifi-3160-13.ucode
 Version: 25.30.13.0
 
 File: iwlwifi-3160-16.ucode
-Version 16.242414.0
+Version: 16.242414.0
 
 File: iwlwifi-3160-17.ucode
-Version 17.bfb58538.0
+Version: 17.bfb58538.0
 
 File: iwlwifi-7265-8.ucode
 Version: 22.24.8.0
@@ -911,10 +911,10 @@ File: iwlwifi-7265-13.ucode
 Version: 25.30.13.0
 
 File: iwlwifi-7265-16.ucode
-Version 16.242414.0
+Version: 16.242414.0
 
 File: iwlwifi-7265-17.ucode
-Version 17.bfb58538.0
+Version: 17.bfb58538.0
 
 File: iwlwifi-7265D-10.ucode
 Version: 23.15.10.0
@@ -926,73 +926,73 @@ File: iwlwifi-7265D-13.ucode
 Version: 25.30.13.0
 
 File: iwlwifi-7265D-16.ucode
-Version 16.242414.0
+Version: 16.242414.0
 
 File: iwlwifi-7265D-17.ucode
-Version 17.352738.0
+Version: 17.352738.0
 
 File: iwlwifi-7265D-21.ucode
-Version 21.302800.0
+Version: 21.302800.0
 
 File: iwlwifi-7265D-22.ucode
-Version 22.391740.0
+Version: 22.391740.0
 
 File: iwlwifi-7265D-27.ucode
-Version 27.541033.0
+Version: 27.541033.0
 
 File: iwlwifi-7265D-29.ucode
-Version 29.3e3b4de5.0
+Version: 29.3e3b4de5.0
 
 File: iwlwifi-3168-21.ucode
-Version 21.302800.0
+Version: 21.302800.0
 
 File: iwlwifi-3168-22.ucode
-Version 22.391740.0
+Version: 22.391740.0
 
 File: iwlwifi-3168-27.ucode
-Version 27.541033.0
+Version: 27.541033.0
 
 File: iwlwifi-3168-29.ucode
-Version 29.3e3b4de5.0
+Version: 29.3e3b4de5.0
 
 File: iwlwifi-8000C-13.ucode
 Version: 25.30.13.0
 
 File: iwlwifi-8000C-16.ucode
-Version 16.242414.0
+Version: 16.242414.0
 
 File: iwlwifi-8000C-21.ucode
-Version 21.302800.0
+Version: 21.302800.0
 
 File: iwlwifi-8000C-22.ucode
-Version 22.391740.0
+Version: 22.391740.0
 
 File: iwlwifi-8000C-27.ucode
-Version 27.541033.0
+Version: 27.541033.0
 
 File: iwlwifi-8000C-31.ucode
-Version 31.560484.0
+Version: 31.560484.0
 
 File: iwlwifi-8000C-34.ucode
-Version 34.610288.0
+Version: 34.610288.0
 
 File: iwlwifi-8000C-36.ucode
-Version 36.7596afd4.0
+Version: 36.7596afd4.0
 
 File: iwlwifi-8265-21.ucode
-Version 21.302800.0
+Version: 21.302800.0
 
 File: iwlwifi-8265-22.ucode
-Version 22.391740.0
+Version: 22.391740.0
 
 File: iwlwifi-8265-27.ucode
-Version 27.541033.0
+Version: 27.541033.0
 
 File: iwlwifi-8265-31.ucode
-Version 31.560484.0
+Version: 31.560484.0
 
 File: iwlwifi-8265-34.ucode
-Version 34.610288.0
+Version: 34.610288.0
 
 File: iwlwifi-8265-36.ucode
 Version: 36.7596afd4.0
-- 
2.17.0
