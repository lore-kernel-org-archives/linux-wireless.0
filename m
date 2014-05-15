Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46015 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbaEOJjd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 05:39:33 -0400
Message-ID: <1400146757.4146.1.camel@jlt4.sipsolutions.net> (sfid-20140515_113938_466916_E0B03E4D)
Subject: Re: [PATCH] cfg80211: fix start_radar_detection issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho, Luciano" <luciano.coelho@intel.com>
Date: Thu, 15 May 2014 11:39:17 +0200
In-Reply-To: <CAB3XZEcixQDE7FbvJ2k3jw501BjS2_LkKG72zYok6WbmzCxq5A@mail.gmail.com> (sfid-20140515_112846_166140_C2756793)
References: <1400066704-7286-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1400078561.4759.12.camel@jlt4.sipsolutions.net>
	 <CAB3XZEcixQDE7FbvJ2k3jw501BjS2_LkKG72zYok6WbmzCxq5A@mail.gmail.com>
	 (sfid-20140515_112846_166140_C2756793)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-15 at 12:28 +0300, Eliad Peller wrote:
> On Wed, May 14, 2014 at 5:42 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-05-14 at 13:25 +0200, Janusz Dziedzic wrote:
> >> After patch:
> >> cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
> >>
> >> start_radar_detection always fail with -EINVAL.
> >
> > Applied, thanks.
> >
> probably a bit late, but i don't really see why passing
> NL80211_IFTYPE_UNSPECIFIED at all, instead of the iftype?

I did briefly wonder about the same, but decided Luca probably knew
better :)

johannes

