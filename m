Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47342 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbbFQK7D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 06:59:03 -0400
Message-ID: <1434538739.1884.37.camel@sipsolutions.net> (sfid-20150617_125911_218571_773CEFC1)
Subject: Re: [PATCH V4] mac80211: minstrel_ht: Handle Dynamic SMPS state of
 the peer.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 17 Jun 2015 12:58:59 +0200
In-Reply-To: <CABPxzYKoVruvBuzwPLmVcG2Aemhgmo+zbR3rPkLg-WRqswpG9w@mail.gmail.com> (sfid-20150617_121800_123780_357F578A)
References: <1434056692-8011-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1434532138.1884.22.camel@sipsolutions.net>
	 <CABPxzYKoVruvBuzwPLmVcG2Aemhgmo+zbR3rPkLg-WRqswpG9w@mail.gmail.com>
	 (sfid-20150617_121800_123780_357F578A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-17 at 15:47 +0530, Krishna Chaitanya wrote:
> On Wed, Jun 17, 2015 at 2:38 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2015-06-12 at 02:34 +0530, Chaitanya T K wrote:
> >> In case of Dynamic SMPS enable RTS/CTS for all rates.
> >
> > Applied. I really think you should drop the "." at the end of the
> > subject though :)
> >
> Oh..will drop it. Is there any special reason?

Not really. Just consistency and personal preference.

johannes

