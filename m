Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34715 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYJURsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 13:48:52 -0400
Date: Tue, 21 Oct 2008 13:48:00 -0400
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
Message-ID: <20081021174800.GJ17268@tuxdriver.com> (sfid-20081021_194855_996044_E794BF93)
References: <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com> <1224554323.24677.248.camel@debian.sh.intel.com> <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com> <1224561748.24677.274.camel@debian.sh.intel.com> <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com> <1224569252.9386.77.camel@californication> <43e72e890810202329g732a97ccxf176bdf4e035ccda@mail.gmail.com> <1224571890.9386.85.camel@californication> <20081021171328.GG17268@tuxdriver.com> <1224611033.9386.98.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224611033.9386.98.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 07:43:53PM +0200, Marcel Holtmann wrote:

> > > No we can't have a new (or updated) driver require new userspace. If you
> > > install a 2.6.30 kernel on an Ubuntu Hardy system, it should make the
> > > hardware work without installing an extra userspace component. And yes,
> > > it works for the first card if it provides a regulatory hint, but it
> > > should also work for the second card.
> > 
> > That is what WIRELESS_OLD_REGULATORY is for, no?
> 
> but that would go away with 2.6.29 if it proceeds as planned.

I don't see a huge maintenance burden to it the way it is implemented
now.  I know Luis will hate the idea, but perhaps we could just let
it linger indefinitely?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
