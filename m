Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx27.mail.ru ([94.100.176.41]:53909 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZGaK7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 06:59:09 -0400
Subject: Re: [RFC PATCH] rt2x00: FIF_PSPOLL filter flag support
From: Igor Perminov <igor.perminov@inbox.ru>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1249037282.2143.15.camel@sunlight>
References: <1249037282.2143.15.camel@sunlight>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 14:59:07 +0400
Message-Id: <1249037947.2143.23.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 31/07/2009 at 14:48 +0400, Igor Perminov wrote:
> This patch implements FIF_PSPOLL filter flag support in rt2x00 drivers,
> which has been introduced in mac80211 (see
> http://marc.info/?l=linux-wireless&m=124897986330807&w=2).

This patch implements support of FIF_PSPOLL for all drivers in
drivers/net/wireless/rt2x00 directory. Including rt2400pci, rt2500pci
and rt2500usb, which are not modified at all.

I've tested the patch with rt73usb and rt2500usb sticks only.
Unfortunately, I have no other kinds of Ralink hardware.

Igor

