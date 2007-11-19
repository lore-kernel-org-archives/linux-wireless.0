Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:3051 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbXKSIes (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 03:34:48 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: 88w8335 [Libertas] 802.11b/g
Date: Mon, 19 Nov 2007 09:34:59 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
References: <43e72e890711161733o72b557ccs63fa1c0104bc656a@mail.gmail.com>
In-Reply-To: <43e72e890711161733o72b557ccs63fa1c0104bc656a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711190934.59367.hs4233@mail.mn-solutions.de> (sfid-20071119_083450_766754_5869BFA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> vendor:device -- 11ab:1faa
>
> libertas_cs isn't picking up though.

libertas wasn't written for 8335 chips. The whole of libertas, 
including "if_cs.c", is currently only for 8385 chips.

I saw a driver for 8335 chips at 
http://david.woodhou.se/mrv.tar.gz. Do you refer to the same 
one?

As this driver was originally written for mac80211, I'd prefer it 
over a driver/net/wireless/libertas based driver, e.g. via an 
hyptothetical "if_pci.c". Maybe you need to dust of a bit of 
bitrot. Maybe it's even worth pushing this driver into shape and 
submitting it to Linville for kernel adoption.
