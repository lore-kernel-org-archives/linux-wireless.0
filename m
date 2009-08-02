Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:43288 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZHBJOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 05:14:50 -0400
Received: by ewy10 with SMTP id 10so2399340ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 02:14:50 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 2 Aug 2009 10:14:50 +0100
Message-ID: <efe7343f0908020214m6d8b2518n51d4264943ce273a@mail.gmail.com>
Subject: Unsupported PHY on B43
From: Luis Correia <luis.f.correia@gmail.com>
To: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

first of all, if linux-wireless isn't the correct list for this, then
please point me into the right direction.

I got a new laptop from my employer which includes a b43 wireless
card, that isn't working with current git kernel (actually it is the
rt2x00 branch from Ivo).

Here are the messages I get from 'dmesg'.

b43-phy1: Broadcom 4322 WLAN found (core revision 16)
b43-phy1 ERROR: FOUND UNSUPPORTED PHY (Analog 8, Type 4, Revision 4)
b43: probe of ssb0:0 failed with error -95
Broadcom 43xx driver loaded [ Features: PML, Firmware-ID: FW13 ]

I'm available to test drivers, patches, git kernels, the whole lot.

(I'm going to use this laptop to work on rt2x00, although the
available antennas aren't quite compatible, as they are for 3G module)

Luis Correia
rt2x00 project admin
