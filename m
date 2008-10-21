Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44163 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYJUGGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 02:06:41 -0400
Subject: Re: New Regulatory Domain Api.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com>
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
Content-Type: text/plain
Date: Tue, 21 Oct 2008 08:07:32 +0200
Message-Id: <1224569252.9386.77.camel@californication> (sfid-20081021_080644_077602_40478DFA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> >> The proper solution is to either add 5 GHz regulatory rules to your
> >> regulatory_hint() and/or rely on crda to enable the 5 GHz channels
> >> required for the country the user is in. It is true that you need
> >> manual intervention and the way I am trying to resolve that is not by
> >> changing the design of the current regulatory infrastructure, instead
> >> I want to add country selection support to say wpa_supplicant or
> >> Network Manager. That, IMO, is how to address the problem correctly. I
> >> also suggested a temporary solution which a distribution can use which
> >> requires absolutely no manual user intervention, that of determining
> >> the country through whatever means the distribution deems more fit and
> >> calling iw reg set on $COUNTRY.
> >
> > See Marcel's comment on supporting new kernels with old applications.
> 
> Old userspace still works, we can however require new userspace for
> new features. A compliant regulatory infrastructure is a feature.

how does an old userspace with a new kernel works? If we essentially
disable hardware by not having the userspace in place, then that is not
a solution. We have to be able to install a new or development kernel on
an old distro without having to install crda/iw or updating udev or
whatever.

Regards

Marcel


