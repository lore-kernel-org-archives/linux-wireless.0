Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:13527 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZC3XYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 19:24:11 -0400
MIME-Version: 1.0
Date: Tue, 31 Mar 2009 01:24:08 +0200
Message-ID: <15d0b9b20903301624j45040f38tdd1ce5400bbaa247@mail.gmail.com> (sfid-20090331_012414_524069_EF21ED04)
Subject: Additional USB identifier for rt2870 driver
From: Daniele Napolitano <dnax88@gmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the patch for Sitecom WL-315:

Signed-off-by: Daniele Napolitano <dnax88@gmail.com>
--- rt2870.h 2009-02-07 01:27:09.000000000 +0100
+++ rt2870.h~ 2009-02-07 01:26:58.000000000 +0100
@@ -95,6 +95,7 @@
  {USB_DEVICE(0x0DF6,0x002B)}, /* Sitecom */ \
  {USB_DEVICE(0x0DF6,0x002C)}, /* Sitecom */ \
  {USB_DEVICE(0x0DF6,0x002D)}, /* Sitecom */ \
+ {USB_DEVICE(0x0DF6,0x0039)}, /* Sitecom */ \
  {USB_DEVICE(0x14B2,0x3C06)}, /* Conceptronic */ \
  {USB_DEVICE(0x14B2,0x3C28)}, /* Conceptronic */ \
  {USB_DEVICE(0x2019,0xED06)}, /* Planex Communications, Inc. */

-- 
Daniele "DnaX" Napolitano
https://launchpad.net/~dnax88
