Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:57788 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3BDRug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:50:36 -0500
Received: by mail-qa0-f48.google.com with SMTP id j8so1398389qah.14
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 09:50:35 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 4 Feb 2013 18:50:35 +0100
Message-ID: <CAOAX8-kdHOiSWZAVrhRfF94a60QdAT3VfCy9Y+1W9A=i-bzFLQ@mail.gmail.com> (sfid-20130204_185043_671934_9D2491CE)
Subject: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
From: Thomas Rosenkranz <tom.rosary@googlemail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

regarding to:
0bda:819a RTL8188CUS WLAN doesn't work out of the box in downstream
and upstreamkernel
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1102179

xose.vazquez@gmail.com wanted me to test in different system the
following commands:

# sudo su
# modprobe -v rtl8192cu
# echo "0bda 819a" > /sys/bus/usb/drivers/rtl8192cu/new_id
(# dmesg (log output))

then X crashes with the echo command and I see the dmesg output
I can't get back to X and I'm not able to reach any tty-shell.

Tested with 64bit-isos Ubuntu 12.04 / 12.10 / Fedora 17 / Fedora
18beta and upstream kernel linux-image-3.8.0-030800rc4-generic
