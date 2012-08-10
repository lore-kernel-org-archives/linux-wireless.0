Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab2HJQ0G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 12:26:06 -0400
Date: Fri, 10 Aug 2012 18:25:33 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH v3 1/7] nl80211/cfg80211: add radar detection
 command/event
Message-ID: <20120810162532.GA17559@redhat.com> (sfid-20120810_182611_153256_09F81595)
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
 <1344426823-1795-2-git-send-email-victorg@ti.com>
 <20120809115109.GB3516@redhat.com>
 <CAK80WHYjhBbE5Y2Q_-QhbNmxu76BMRCa9=vFyMXwQJQqsGiPUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK80WHYjhBbE5Y2Q_-QhbNmxu76BMRCa9=vFyMXwQJQqsGiPUQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 09, 2012 at 03:08:59PM +0300, Goldenshtein, Victor wrote:
> On Thu, Aug 9, 2012 at 2:51 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Wed, Aug 08, 2012 at 02:53:37PM +0300, Victor Goldenshtein wrote:
> >> +     cac_type = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
> >> +     if (cac_type != NL80211_CHAN_HT20)
> >> +             return -EOPNOTSUPP;
> > Since only HT20 is supported, what for we have this variable?
> >
> 
> Security measures and preparation for future HT40.

I dislike "preparation for future" thing. We have lot of stuff like
that in kernel, which never get implemented, and only mess up the code.

How near future is that?

Also what about pure, non HT, channels?

Stanislaw
