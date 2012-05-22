Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36686 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab2EVUfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 16:35:32 -0400
Received: by eaak11 with SMTP id k11so1812477eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2012 13:35:30 -0700 (PDT)
Message-ID: <4FBBF88F.5060508@gmail.com> (sfid-20120522_224005_480524_F7DDF74D)
Date: Tue, 22 May 2012 22:35:27 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: rt2x00: missing devices/chips
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:

> Xose Vazquez Perez (4):
> wireless: rt2x00: rt2800pci add more RT539x ids
> wireless: rt2x00: rt2800usb add more devices ids
> wireless: rt2x00: rt2800usb more devices were identified

Those were my final patches, from now on MediaTek Inc. guys
should take over it.

These are pending:

- RT3573:
0x1875,0x7733 RT3573 Air Live
0x7392,0x7733 RT3573 Edimax
0x0e66,0x0021 RT3573 Hawking
0x2019,0xed19 RT3573 Planex
0x148f,0x3573 RT3573 Ralink
0x0df6,0x0067 RT3573 Sitecom

- RT5572:
0x148f,0x5572 RT5572 Ralink
0x043e,0x7a32 RT5572 Arcadyan
0x2001,0x3c1a RT5572 D-Link DWA-160-B2

- Identify all UNKNOWN devices in rt2800usb.c

- There is also a handful of them(rt2800{usb,pci}) inside
the inf file of the Windows drivers missing.
