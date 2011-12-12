Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1LLRsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 12:48:06 -0500
Subject: Re: iwlwifi havoc on some APs (rekeying?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EE5E3CD.1070409@gmx.net> (sfid-20111212_122224_090419_DF83BB07)
References: <4EE2202A.4080303@gmx.net>
	 <1323446534.13074.96.camel@wwguy-huron>  <4EE24DF4.4020301@gmx.net>
	 <1323451436.13074.158.camel@wwguy-huron>
	 (sfid-20111209_192243_598986_F6275AE2) <1323455216.3622.21.camel@jlt3.sipsolutions.net>
	 <4EE35877.1060507@gmx.net>
	 (sfid-20111210_140255_490293_C3C0F113) <1323680657.3442.7.camel@jlt3.sipsolutions.net>
	 <4EE5D2D3.406@gmx.net>
	 (sfid-20111212_110955_792336_68917631) <1323684754.3442.36.camel@jlt3.sipsolutions.net>
	 <4EE5E3CD.1070409@gmx.net> (sfid-20111212_122224_090419_DF83BB07)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 18:48:02 +0100
Message-ID: <1323712082.3442.43.camel@jlt3.sipsolutions.net> (sfid-20111212_184810_451939_4204EA6D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-12 at 12:21 +0100, Wolfgang Breyha wrote:
> Johannes Berg wrote, on 12.12.2011 11:12:
> > Interesting. We'll have to play with this. Can you try running a 64-bit
> > kernel maybe and see if that fixes things?
> 
> I can try with a F16 x86_64 live image. It's not the latest iwlwifi then, but
> it happend with the F16 iwlagn too anyway;-) I'll do that in the evening and
> report.

A colleague pointed out that due to the PCI address space hold we might
be seeing larger addresses -- could you try booting the 32 bit kernel
with "mem=3G" on the command line (edit it in grub maybe?) and see if
you can still reproduce it then?

johannes

