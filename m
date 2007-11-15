Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:2703 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774AbXKOSgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 13:36:24 -0500
Received: by mu-out-0910.google.com with SMTP id i10so649630mue
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2007 10:36:22 -0800 (PST)
Message-ID: <c85cb4470711151036j11fc855fnfde4366c11df97b@mail.gmail.com> (sfid-20071115_183629_764906_52679CCC)
Date: Thu, 15 Nov 2007 20:36:10 +0200
From: "Ron Rindzonski" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/15] mac80211/iwlwifi (#everything): integrate IEEE802.11n support
Cc: "Guy Cohen" <guy.cohen@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com
In-Reply-To: <1195150317.8147.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
	 <1195056662.4091.29.camel@johannes.berg>
	 <247d6d340711150233h7988220fifb0d34170d16a979@mail.gmail.com>
	 <1195142683.13846.62.camel@johannes.berg>
	 <c85cb4470711151006j765831f9w2fb941317153712c@mail.gmail.com>
	 <1195150317.8147.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I would have to mention at this point that A-MSDU deaggregation is
> > obligatory according to the 802.11n, so excluding it would be a spec
> > violation.
>
> Right. But does that really matter for purposes of getting the code into
> a development tree? What we're aiming for here is getting the code out
> of your hands so that it won't conflict with other stuff that's work in
> progress, rather than aiming for spec compliance (which is something I'd
> aim for when merging this stuff up into Linus's tree)
>

Oh, sorry for misunderstanding you folks.
Yes, getting the code into the development tree will be excellent.
I am already working on the rx_h_data fix we talked about, and will sent it
over early next week to wrap things up.
Thanks
ron

> > What I will do is to put some out-of-band effort here, fixing the
> > rx_h_data infrastructure, so it will be able to support rx_h_amsdu as
> > well, thus eliminating the EAPOL bug.
>
> Thanks much!
>
> johannes
>
>
