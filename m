Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41600 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYJUGqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 02:46:55 -0400
Subject: Re: New Regulatory Domain Api.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224571229.27899.63.camel@johannes.berg>
References: <20081015112517.GF6509@tesla>
	 <1224485431.18024.12.camel@johannes.berg>
	 <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 <1224561748.24677.274.camel@debian.sh.intel.com>
	 <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com>
	 <1224569252.9386.77.camel@californication>
	 <1224571229.27899.63.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 08:47:40 +0200
Message-Id: <1224571660.9386.80.camel@californication> (sfid-20081021_084657_297567_0F51AF5F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > how does an old userspace with a new kernel works? If we essentially
> > disable hardware by not having the userspace in place, then that is not
> > a solution. We have to be able to install a new or development kernel on
> > an old distro without having to install crda/iw or updating udev or
> > whatever.
> 
> I'm not sure where you're coming from. We can always keep the built-in
> option for EMBEDDED, but currently if you enable the "old static
> regdoms" option there's no regression at all vs. current kernels.

the kernel drivers will changes and thus will start using the new
regulatory infrastructure. And the old static one will go away. So when
we reach the point of a 2.6.29 or 2.6.30 kernel, we still have to make
it run and work as of now with the current userspace.

Regards

Marcel


