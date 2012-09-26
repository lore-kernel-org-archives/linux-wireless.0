Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:43216 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2IZORq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 10:17:46 -0400
Message-ID: <1348669043.13371.12.camel@aeonflux> (sfid-20120926_161750_583170_12B39BD2)
Subject: Re: [PATCH] ath3k: Added VID/PID for the Gigabyte GC-WB300D
 Wifi/Bluetooth card
From: Marcel Holtmann <marcel@holtmann.org>
To: Wouter Thielen <wouter@morannon.org>
Cc: mcgrof@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 26 Sep 2012 16:17:23 +0200
In-Reply-To: <CACySJQUFfxKNAK7J0Qu7QoQhSjdUk+SJ8eZoE+9RQFMKspewLQ@mail.gmail.com>
References: <CACySJQUFfxKNAK7J0Qu7QoQhSjdUk+SJ8eZoE+9RQFMKspewLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wouter,

> This card is supplied with the Gigabyte Sniper 3 motherboard (and some
> others). I followed the information on
> http://wireless.kernel.org/en/users/Drivers/ath3k and confirmed with
> lsusb -v that it is using the AR3012 chipset.

send this to linux-bluetooth@vger.kernel.org since otherwise it will get
lost. And we require inclusion of /sys/kernel/debug/usb/devices for this
one.

Regards

Marcel



