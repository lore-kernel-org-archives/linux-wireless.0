Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40508 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbYJUROZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 13:14:25 -0400
Date: Tue, 21 Oct 2008 13:13:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081021171328.GG17268@tuxdriver.com> (sfid-20081021_191443_841910_9D048995)
References: <1224520999.9386.72.camel@californication> <1224552899.24677.245.camel@debian.sh.intel.com> <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com> <1224554323.24677.248.camel@debian.sh.intel.com> <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com> <1224561748.24677.274.camel@debian.sh.intel.com> <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com> <1224569252.9386.77.camel@californication> <43e72e890810202329g732a97ccxf176bdf4e035ccda@mail.gmail.com> <1224571890.9386.85.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224571890.9386.85.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 08:51:30AM +0200, Marcel Holtmann wrote:

> > And you can use new kernels on old distributions with old wireless
> > drivers, however new mac80211 based drivers can reasonably require new
> > userspace utilities, and in this case we have a new userspace
> > requirement *only* when cfg80211/mac80211 based drivers do not provide
> > their own regutory_hint() or in the particular case outlined in this
> > thread. Additionally this new feature allows users who want to be more
> > compliant to do so by s specifying a country.
> 
> No we can't have a new (or updated) driver require new userspace. If you
> install a 2.6.30 kernel on an Ubuntu Hardy system, it should make the
> hardware work without installing an extra userspace component. And yes,
> it works for the first card if it provides a regulatory hint, but it
> should also work for the second card.

That is what WIRELESS_OLD_REGULATORY is for, no?

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
