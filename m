Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29972 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYJTHWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 03:22:40 -0400
Subject: Re: New Regulatory Domain Api.
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
References: <20081015112517.GF6509@tesla>
	 <1224126030.24677.78.camel@debian.sh.intel.com>
	 <20081016113848.GB5899@tesla>
	 <1224471102.24677.124.camel@debian.sh.intel.com>
	 <43e72e890810192040w567fa4f6j1bf40e80084a857e@mail.gmail.com>
	 <1224479933.24677.148.camel@debian.sh.intel.com>
	 <43e72e890810192333r7b3f6a0m56d499d0aed9240e@mail.gmail.com>
	 <1224484685.18024.5.camel@johannes.berg>
	 <43e72e890810192346q5e0eadbcm26febe45392a2172@mail.gmail.com>
	 <1224485431.18024.12.camel@johannes.berg>
	 <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 15:22:20 +0800
Message-Id: <1224487340.24677.192.camel@debian.sh.intel.com> (sfid-20081020_092244_433853_F4181EFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 00:59 -0600, Luis R. Rodriguez wrote:
> > Ack on both points, which is why I said "If we're going to [...]". I
> > don't think I've seen a convincing use case for this other than test
> > environments, in which you can very well just use crda.
> 
> Ah, ok :)

OK, my point is here:
http://marc.info/?l=linux-wireless&m=122403515521098&w=2

Maybe Marcel has more to say when he wakes up...

> Yi, BTW a simple way to get a distribution to add support initially
> for crda is to have as part of an init script to call
> 
> iw reg set $COUNTRY
> 
> where $COUNTRY is determined though whatever distribution heuristics.

Thanks for the info.

Thanks,
-yi

