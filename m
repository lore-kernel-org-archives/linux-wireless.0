Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:38228 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753950Ab1LLTkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 14:40:02 -0500
Message-ID: <4EE6588F.7020704@gmx.net> (sfid-20111212_204016_636083_D9B6D503)
Date: Mon, 12 Dec 2011 20:39:59 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi havoc on some APs (rekeying?)
References: <4EE2202A.4080303@gmx.net>  <1323446534.13074.96.camel@wwguy-huron>  <4EE24DF4.4020301@gmx.net>  <1323451436.13074.158.camel@wwguy-huron>  (sfid-20111209_192243_598986_F6275AE2) <1323455216.3622.21.camel@jlt3.sipsolutions.net>  <4EE35877.1060507@gmx.net>  (sfid-20111210_140255_490293_C3C0F113) <1323680657.3442.7.camel@jlt3.sipsolutions.net>  <4EE5D2D3.406@gmx.net>  (sfid-20111212_110955_792336_68917631) <1323684754.3442.36.camel@jlt3.sipsolutions.net>  <4EE5E3CD.1070409@gmx.net> (sfid-20111212_122224_090419_DF83BB07) <1323712082.3442.43.camel@jlt3.sipsolutions.net>
In-Reply-To: <1323712082.3442.43.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-12-12 18:48, Johannes Berg wrote:
> A colleague pointed out that due to the PCI address space hold we might
> be seeing larger addresses -- could you try booting the 32 bit kernel
> with "mem=3G" on the command line (edit it in grub maybe?) and see if
> you can still reproduce it then?

F16 kernel-3.1.0-7.x86_64 works with and without rekeying.

Greetings, Wolfgang
-- 
Wolfgang Breyha <wbreyha@gmx.net> | http://www.blafasel.at/
Vienna University Computer Center | Austria
