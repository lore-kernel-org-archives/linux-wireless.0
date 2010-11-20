Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42843 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab0KTCoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 21:44:30 -0500
Message-ID: <4CE7360B.7090700@openwrt.org>
Date: Sat, 20 Nov 2010 03:44:27 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k very unstable and kills file-system.
References: <4CE720A1.3090408@candelatech.com>
In-Reply-To: <4CE720A1.3090408@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-20 2:13 AM, Ben Greear wrote:
> It's been another frustrating week for using ath9k.
> 
> With a patched wpa_supplicant (found here:
> https://github.com/greearb/hostap-ct/tree/)
> I can reliably cause ath9k to spew all sorts of DMA warnings
> and evidently crash the hard-drive controller and/or corrupt the
> file system so bad that fsck cannot fix it.  (Back up anything you
> want to keep before attempting to reproduce this.)
The rx dma warnings went away on my devices with my patch
"ath9k: fix timeout on stopping rx dma"
Please try that one and see if it helps with your corruption issues.

- Felix
