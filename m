Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:50019 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYJURnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 13:43:04 -0400
Subject: Re: New Regulatory Domain Api.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081021171328.GG17268@tuxdriver.com>
References: <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 <1224561748.24677.274.camel@debian.sh.intel.com>
	 <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com>
	 <1224569252.9386.77.camel@californication>
	 <43e72e890810202329g732a97ccxf176bdf4e035ccda@mail.gmail.com>
	 <1224571890.9386.85.camel@californication>
	 <20081021171328.GG17268@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 19:43:53 +0200
Message-Id: <1224611033.9386.98.camel@californication> (sfid-20081021_194308_140761_DDEB7FFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> > > And you can use new kernels on old distributions with old wireless
> > > drivers, however new mac80211 based drivers can reasonably require new
> > > userspace utilities, and in this case we have a new userspace
> > > requirement *only* when cfg80211/mac80211 based drivers do not provide
> > > their own regutory_hint() or in the particular case outlined in this
> > > thread. Additionally this new feature allows users who want to be more
> > > compliant to do so by s specifying a country.
> > 
> > No we can't have a new (or updated) driver require new userspace. If you
> > install a 2.6.30 kernel on an Ubuntu Hardy system, it should make the
> > hardware work without installing an extra userspace component. And yes,
> > it works for the first card if it provides a regulatory hint, but it
> > should also work for the second card.
> 
> That is what WIRELESS_OLD_REGULATORY is for, no?

but that would go away with 2.6.29 if it proceeds as planned.

Regards

Marcel


