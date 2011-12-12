Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1LLKMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 05:12:38 -0500
Subject: Re: iwlwifi havoc on some APs (rekeying?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EE5D2D3.406@gmx.net> (sfid-20111212_110955_792336_68917631)
References: <4EE2202A.4080303@gmx.net>
	 <1323446534.13074.96.camel@wwguy-huron>  <4EE24DF4.4020301@gmx.net>
	 <1323451436.13074.158.camel@wwguy-huron>
	 (sfid-20111209_192243_598986_F6275AE2) <1323455216.3622.21.camel@jlt3.sipsolutions.net>
	 <4EE35877.1060507@gmx.net>
	 (sfid-20111210_140255_490293_C3C0F113) <1323680657.3442.7.camel@jlt3.sipsolutions.net>
	 <4EE5D2D3.406@gmx.net> (sfid-20111212_110955_792336_68917631)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 11:12:34 +0100
Message-ID: <1323684754.3442.36.camel@jlt3.sipsolutions.net> (sfid-20111212_111241_586858_F5DEE58D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-12 at 11:09 +0100, Wolfgang Breyha wrote:
> On 12/12/11 10:04, Johannes Berg wrote:
> > Are you running a 32-bit kernel on a 64-bit machine by any chance?
> > Somebody else reported that using a 64-bit kernel helped similar issues.
> 
> That's right. It's F16.i686 on a
> # cat /proc/cpuinfo
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 37
> model name	: Intel(R) Core(TM) i5 CPU       M 540  @ 2.53GHz

Interesting. We'll have to play with this. Can you try running a 64-bit
kernel maybe and see if that fixes things?

johannes

