Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46124 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZKHMls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 07:41:48 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so2346758ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 04:41:53 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [RFC/RFT] rt2x00: Add dynamic detection of eFuse EEPROM in rt2800pci.
Date: Sun, 8 Nov 2009 13:40:15 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1257679835-25269-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257679835-25269-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Message-Id: <200911081340.15474.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 12:30:35 Gertjan van Wingerde wrote:
> Instead of assuming that all rt3090 devices will have an eFuse EEPROM, do as the legacy Ralink driver,
> and detect at run-time whether an eFuse EEPROM is present.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Incidentally I made a very similar patch on Friday as a preparation for
other changes but this version is a bit more readable (cause it adds
rt2800pci_efuse_detect() helper) so I'll replace my version by your patch.
