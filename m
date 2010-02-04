Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51406.mail.re2.yahoo.com ([206.190.38.185]:37420 "HELO
	web51406.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754333Ab0BDIbT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 03:31:19 -0500
Message-ID: <700097.58871.qm@web51406.mail.re2.yahoo.com>
Date: Thu, 4 Feb 2010 00:31:17 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [ath9k-devel] Significiant performance differences between ath5k  and ath9k in 802.11a
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <4B629AF5.40706@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,
with several people confirming the performance regression relative to AR5xxx/ath5k, can you tell us whether this will eventually be fixed? We are close to a purchase decision and would really like to upgrade to a recent chip set.
-- 
Regards
       Joerg


--- Felix Fietkau <nbd@openwrt.org> schrieb am Fr, 29.1.2010:

> Von: Felix Fietkau <nbd@openwrt.org>
> Betreff: Re: [ath9k-devel] Significiant performance differences between ath5k  and ath9k in 802.11a
> An: "Joerg Pommnitz" <pommnitz@yahoo.com>
> CC: rootkit85@yahoo.it, linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org
> Datum: Freitag, 29. Januar 2010, 9:23
> On 2010-01-29 9:10 AM, Joerg Pommnitz
> wrote:
> > --- rootkit85@yahoo.it
> <rootkit85@yahoo.it>
> wrote:
> > 
> >> 
> >> Can you try in AP-client mode? I think you'll get
> more
> >> throughput so.
> >> 
> > 
> > No, IBSS is what I'm interested in. And the point is,
> that there is
> > a 30% performance difference between ath5k (and
> Madwifi) and ath9k. Even
> > if the performance in AP mode would be better, this
> does not change the
> > problem in IBSS mode.
> I can confirm these numbers for AP/Client mode as well.
> I've even tested
> legacy communication between ath9k ap and sta, producing
> the same
> result. Additionally, I can rule out the rate control
> algorithm, as
> using minstrel instead of the ath9k RC produces a very
> similar
> throughput test result.
> 
> - Felix
> 

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
