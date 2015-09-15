Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39966 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbbIOHFI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 03:05:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ZbkIb-00034T-0f
	for linux-wireless@vger.kernel.org; Tue, 15 Sep 2015 09:05:05 +0200
Received: from 217.113.177.185 ([217.113.177.185])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2015 09:05:04 +0200
Received: from chris by 217.113.177.185 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2015 09:05:04 +0200
To: linux-wireless@vger.kernel.org
From: Chris <chris@dd-wrt.com>
Subject: Re: [PATCH 4.3] ath10k: fix DMA related firmware crashes on multiple devices
Date: Tue, 15 Sep 2015 07:03:34 +0000 (UTC)
Message-ID: <loom.20150915T085937-648@post.gmane.org> (sfid-20150915_090516_750741_DAD967BD)
References: <1442176540-34973-1-git-send-email-nbd@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


Felix Fietkau <nbd@...> writes:

> 
> Some platforms really don't like DMA bursts of 256 bytes, and this
> causes the firmware to crash when sending beacons.
> Also, changing this based on the firmware version does not seem to make
> much sense, so use 128 bytes for all version

i can confirm that now gateworks laguna / Ventana and Compex wpj344 (HW v1
and v2) is how working with one and more 9880 cards, using actual firmwares
(tested firmware-5.bin_10.2.4.70-2 + firmware-5.bin_10.2.4.70.6-2 )




