Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38486 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZGAVvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 17:51:55 -0400
Subject: Re: Insist on cfg80211 for new drivers?
From: Marcel Holtmann <marcel@holtmann.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <20090701193657.GD3473@tuxdriver.com>
References: <1246388712.4949.52.camel@localhost>
	 <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	 <1246396179.4949.76.camel@localhost>
	 <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	 <1246464991.4331.18.camel@localhost> <4A4BA21F.1070101@gmail.com>
	 <43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com>
	 <1246473300.30522.10.camel@localhost.localdomain>
	 <20090701193657.GD3473@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 14:52:03 -0700
Message-Id: <1246485123.12994.168.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> > That's really all I
> > care about, I don't want another WEXT-based driver accepted; I want all
> > the new ones using cfg80211.
> 
> Now there is a discussion we should have had in Berlin...is it time
> to insist on cfg80211-based configuration for all new drivers?

there is really nothing much to discuss on this topic. The plan is to
deprecate WEXT, that simple. So if the driver has no cfg80211 support,
then it will not be included. Period.

Send such drivers off to staging and let them have their 6 month. Then
we either remove them again or they got ported to cfg80211.

Regards

Marcel


