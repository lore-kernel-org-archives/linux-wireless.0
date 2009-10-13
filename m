Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:37593 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZJMUB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 16:01:28 -0400
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Tue, 13 Oct 2009 22:00:48 +0200
Cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
	linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910132017.47748.IvDoorn@gmail.com> <200910132121.25743.bzolnier@gmail.com>
In-Reply-To: <200910132121.25743.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910132200.48569.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > The rt2800pci and rt2800usb drivers cover support for rt2860/rt2870/rt3070 devices,
> > which are present as individual drivers in the staging tree. So far it only managed
> 
> There are no longer individual drivers.
> 
> Instead there is one shared source code and two device drivers:
> 
> - rt2860 covering RT2860 and RT3090 devices
> 
> - rt2870 covering RT2870 and RT3070 devices

Cool, now you only need somebody to update those drivers to mac80211,
and you can merge those drivers to the main drivers/net/wireless/ folder.

Can't be more happy with this progress, since that means I can finally abandon
rt2800pci and rt2800usb which have been nothing more then a pain.

Ivo

P.S.
It is up to you to decide if this mail was intented as serious, sarcastic or pointless ranting.
