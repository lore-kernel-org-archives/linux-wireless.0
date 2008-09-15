Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39142 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbYIOUtx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 16:49:53 -0400
Date: Mon, 15 Sep 2008 13:49:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<Jouni.Malinen@atheros.com>
Subject: Re: [PATCH 2/2] Don't destroy authentication algorithm before
	authenticating.
Message-ID: <20080915204940.GF22572@tesla> (sfid-20080915_224958_942703_B096A71D)
References: <48CE8452.9080604@odi.ch> <1221494039.3700.47.camel@johannes.berg> <48CE86B6.6080704@odi.ch> <1221494673.3700.54.camel@johannes.berg> <48CE8FBE.2040000@odi.ch> <1221502509.3700.71.camel@johannes.berg> <48CEB155.9070401@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <48CEB155.9070401@odi.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 12:02:45PM -0700, Ortwin Gl=FCck wrote:
> Johannes Berg wrote:
> > The packet capture indicates that the packets are retransmitted
> > indicating  that the AP isn't even acknowledging them, which in tur=
n
> > indicates it's not receiving them. This suggests there's something =
wrong
> > with ath9k, are you positive it works with those mac80211 hacks?
> >
> > johannes
>=20
> You're very right. I just moved my laptop into the same room where th=
e AP is.
> And guess what: auth and association works straight away. Apparently =
ath9k sets
> up the card so badly that the transmission power is extremely low! Al=
so I
> couldn't set any other rate than 1M.

The rate indicated by iwconfig is bogus, we have to fix the reported
rate, we'll do that soon. We'll review this thread too and try to get
this fixed.

Thanks for reporting it.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
