Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:57772 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaKHUj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2014 15:39:59 -0500
Received: by mail-ob0-f173.google.com with SMTP id wn1so4144637obc.4
        for <linux-wireless@vger.kernel.org>; Sat, 08 Nov 2014 12:39:58 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 8 Nov 2014 14:39:58 -0600
Message-ID: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com> (sfid-20141108_214004_481670_6407C93E)
Subject: brcmfmac not working on ECS LIVA
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Cc: arend@broadcom.com, frankyl@broadcom.com,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I just got an ECS LIVA and I haven't been able to get the wireless
working. First I got the error that the brcmfmac43241b4-sdio.txt file
was missing. I got the file from the ECS's beta drivers [1], but it's
still not working.

brcmfmac: brcmf_sdio_drivestrengthinit: No SDIO Drive strength init
done for chip 4324 rev 5 pmurev 17
brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jul 17 2013
07:36:07 version 6.10.197.71 (r412987) FWID 01-882d2634
brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
brcmfmac: brcmf_add_if: ignore IF event

WPA association/authentication failed for interface 'wlan0'

I also tried a nvram file that is stored in EFI variables, but it
didn't work either.

Some things seem to work some times, but not the whole association.

This is a 3.17.2 kernel.

Any ideas?

[1] http://www.ecs.com.tw/LIVA/support.html

-- 
Felipe Contreras
