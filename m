Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:59028
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140Ab3CULTc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 07:19:32 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Karl Beldan <karl.beldan@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: RE: [RFC V2 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
Date: Thu, 21 Mar 2013 11:19:32 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA13590716@mbx022-e1-nj-10.exch022.domain.local> (sfid-20130321_121936_454493_A7BB050F)
References: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
 <1363652600-23223-2-git-send-email-karl.beldan@gmail.com>
 <1363693626.3355.14.camel@WLAN-SW-TEST-03>
 <20130319122836.GA26078@magnum.frso.rivierawaves.com>
 <1363751176.9344.1.camel@WLAN-SW-TEST-03>
 <1363776796.9344.14.camel@WLAN-SW-TEST-03>,<20130320122956.GA12516@magnum.frso.rivierawaves.com>
In-Reply-To: <20130320122956.GA12516@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Karl,

It didn't work. Anyways I will wait till its published to kernel.

Thanks,
Mahesh

________________________________________
From: Karl Beldan [karl.beldan@gmail.com]
Sent: Wednesday, March 20, 2013 5:59 PM
To: Mahesh Palivela
Cc: linux-wireless; Karl Beldan
Subject: Re: [RFC V2 1/2] mac80211: Use a cfg80211_chan_def in ieee80211_hw_conf_chan

On Wed, Mar 20, 2013 at 04:23:16PM +0530, Mahesh Palivela wrote:
> On Wed, 2013-03-20 at 09:16 +0530, Mahesh Palivela wrote:
> > On Tue, 2013-03-19 at 13:28 +0100, Karl Beldan wrote:
> > > On Tue, Mar 19, 2013 at 05:17:06PM +0530, Mahesh Palivela wrote:
> > > > On Tue, 2013-03-19 at 01:23 +0100, Karl Beldan wrote:
> > > > > From: Karl Beldan <karl.beldan@rivierawaves.com>
> >
> > > > > +     local->_oper_chandef.center_freq1 += cfreq_off;
> > > > > +     local->_oper_chandef.center_freq2 += cfreq_off;
> > > >
> > > > can't add cfreq_off to center_freq2. Add only in case of non-zero
> > > > center_freq2?
> > > >
> > > At first I was like "why ?", but I hadn't spotted the places where we
> > > only check for "center_freq2 != 0".
> > >
> > >
> > > Thanks Mahesh, Have you tested vht with this ?
> >
> > Not yet Karl. I will give it a try and update you.
> >
>
> Karl, Is this patch based on mac80211-next kernel? I see failures/hunks
> when apply your patch.
>
It is based on mac80211-next yes.
I did it Sunday so it applies properly @ddbfe86 and does so up to
445ea4e^1, (445ea4e was Tuesday).


Karl
