Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:50772 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab3CQWk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 18:40:29 -0400
Received: by mail-we0-f175.google.com with SMTP id x8so4394745wey.6
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2013 15:40:28 -0700 (PDT)
Date: Sun, 17 Mar 2013 23:40:19 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211/minstrel_ht: add support for using CCK rates
Message-ID: <20130317224019.GA7563@gobelin> (sfid-20130317_234034_463717_80586D14)
References: <1360749068-3977-1-git-send-email-nbd@openwrt.org>
 <20130312094119.GA23062@magnum.frso.rivierawaves.com>
 <1363361818.8656.20.camel@jlt4.sipsolutions.net>
 <20130317212302.GA6886@gobelin>
 <514639B3.4050700@openwrt.org>
 <20130317220737.GB7031@gobelin>
 <CAJ-VmonRkrd5cw_k6uwMFBrvjz95fcDO7rJi5HY8grKeY6Jp5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJ-VmonRkrd5cw_k6uwMFBrvjz95fcDO7rJi5HY8grKeY6Jp5g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 17, 2013 at 03:30:17PM -0700, Adrian Chadd wrote:
> On 17 March 2013 15:07, Karl Beldan <karl.beldan@gmail.com> wrote:
> 
> > The best way I could look at it was that it would let drivers know the frame is
> > being transmitted under BA, but it still changes the meaning and thus
> > the handling of the flag.
> > Frankly, if the meaning "officially" becomes "this frames is being
> > transmitted under BA", as the code behaves, and you seem to say, I am all
> > for it ;)
> 
> Well, having it be "This frame is being transmitted under aggregation"
> can't be guaranteed anyway.
> 
> Eg, imagine the case where your BA window is such that you've sent 0
> .. 63 and only received a BA for 1..63.
> So you have to send one single frame - why would you request a
> blockack and why would you transmit it as an aggregate? :)
> 
When I wrote "under BA", I meant "under BlockAck Aggreement" not "will
be aggregated" ;)
 
Karl
