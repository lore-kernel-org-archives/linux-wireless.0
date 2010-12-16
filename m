Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kandzendo.ru ([195.178.208.66]:38644 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911Ab0LPL5V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 06:57:21 -0500
Date: Thu, 16 Dec 2010 14:57:18 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com
Subject: Re: iwl rfkill suddenly dropped to hard block
Message-ID: <20101216115717.GA15075@ioremap.net>
References: <20101215195651.GA18545@ioremap.net>
 <20101215201126.GG2377@tuxdriver.com>
 <20101216032247.GA7345@ioremap.net>
 <4D099444.5040703@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D099444.5040703@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 15, 2010 at 10:23:32PM -0600, Larry Finger (Larry.Finger@lwfinger.net) wrote:
> >I would imagine this is just related to some dellish crap, but I saw a
> >number of exactly the same cases in the web including linux-kernel mail
> >lists in the past and also without 'slider on the back' case.
> 
> I doubt that it is Dell related, if that is what "dellish" means.
> 
> I have had some success in clearing this problem by unloading and
> reloading the wireless driver. I had the problem on one box that has
> no rfkill switch and an 802.11b card that uses b43legacy.

I tried that as well as disabling and enabling wifi in bios (or is it
newr loader), but without success. I called this 'dellish' crap
because of the hell list of problems I had with this laptop and i915
video chipset in it. Apparently brother model e4200 does not have them
at all.

-- 
	Evgeniy Polyakov
