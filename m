Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49658 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2KLV6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:58:48 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3644080eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:58:47 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Subject: [PATCH 00/17] RTL8187SE driver cleanups
Date: Mon, 12 Nov 2012 23:58:14 +0200
Message-Id: <1352757511-26957-1-git-send-email-maxtram95@gmail.com> (sfid-20121112_225852_000284_10E9AD1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some bug fixes, cleanups and dead code removal for
drivers/staging/rtl8187se
----------------------------------------------------------------
Maxim Mikityanskiy (17):
      Removed dead functions
      Removed legacy rtl8225_rf_set_chan()
      Removed empty functions and one-iteration loop
      Fixed bugs in interrupt handler
      Simplified function GetSupportedWirelessMode8185()
      Fix oops when rmmoding
      Removed unused module parameters and fixed module description
      Removed dead code
      Removed unused parameters of HwHSSIThreeWire()
      Fixed typo in TransmitConfig
      Removed non-existent function headers from r8180.h
      Removed unused arrays in r8180_rtl8225z2.c
      Use ARRAY_SIZE instead of in-code constants
      Removed unneeded reads from EEPROM
      Removed unused fields in r8180_priv
      Fixed size of BEACON_INTERVAL register
      Removed empty stub read_acadapter_file()

 r8180.h           |   28 ------
 r8180_core.c      |  436 ++++---------------------------------------------------------------------------------
 r8180_rtl8225.h   |    2 +-
 r8180_rtl8225z2.c |  229 +++------------------------------------------
 r8185b_init.c     |  223 ++++++++++++-------------------------------
 5 files changed, 91 insertions(+), 827 deletions(-)
