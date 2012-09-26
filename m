Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56939 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2IZLCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 07:02:38 -0400
Received: by wgbdr13 with SMTP id dr13so410733wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 04:02:37 -0700 (PDT)
Message-ID: <5062E0CB.6040308@gmail.com> (sfid-20120926_130241_840733_025514D8)
Date: Wed, 26 Sep 2012 12:02:35 +0100
From: Ben Gray <ben.r.gray@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ath6kl-devel@qualcomm.com
Subject: ath6kl ar6004/ar9374 (hw 1.3) WPA/WPA2 supported ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

     I have a bunch of UB134 USB dongles which have a ath6kl chip with 
H/W version 0x31c8088a, I'm trying to get them to work with the ath6kl 
driver from the compat-wireless-3.6-rc5-1 package. I've applied this 
(https://patchwork.kernel.org/patch/1203191/) patch to the source and 
pulled the hw1.3 firmware from the linux-firmware git.

     The driver works as far as it can scan AP's and connect to 
unencrypted networks, however WPA/WPA2 doesn't work when I run 
wpa_supplicant. I realise "WPA doesn't work" is a bit vague, and I can 
post the wpa_supplicant and driver logs if that helps, but I've seen 
another post which says they couldn't get WPA to work either, so I'd 
like to know if this is a known issue with the driver and/or firmware? 
Has anyone had any luck getting WPA/WPA2 working with ath6kl hw1.3 ?

     If this is a known issue does anyone know when it might be fixed ?


Thanks in advance,
Ben.

