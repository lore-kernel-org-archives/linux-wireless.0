Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39602 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab1CROBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:01:03 -0400
Date: Fri, 18 Mar 2011 09:50:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org, vmehta@atheros.com,
	naveen.singh@atheros.com, stable@kernel.org,
	Naveen Singh <nsingh@atheros.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: [RTF] iwmc3200wifi: fix device registration ordering for cfg80211
Message-ID: <20110318135058.GE5103@tuxdriver.com>
References: <1300417820-19029-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTi=58JJNoYG7232ykiOnAK2TX18ROxrfYQir3Wwe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=58JJNoYG7232ykiOnAK2TX18ROxrfYQir3Wwe@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2011 at 08:11:17PM -0700, Luis R. Rodriguez wrote:
> On Thu, Mar 17, 2011 at 8:10 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > Without this you can get a race against udev and userspace daemons
> > which will try to poke the device even before netdev ops and friends
> > are available. Device initialization will fail without this.
> >
> > Cc: stable@kernel.org
> > Cc: Naveen Singh <nsingh@atheros.com>
> > Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > Cc: Intel Linux Wireless <ilw@linux.intel.com>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> 
> Oops sorry, this was supposed to go to Linville.

And probably "[RFT]" instead of "[RTF]" too. :-)

Does anyone even have this hardware?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
