Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-1.exch022.serverdata.net ([206.225.164.184]:49950
	"EHLO HUB022-nj-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211Ab3CTDqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 23:46:24 -0400
Message-ID: <1363751176.9344.1.camel@WLAN-SW-TEST-03> (sfid-20130320_044629_038769_4EDE9B69)
Subject: Re: [RFC V2 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
From: Mahesh Palivela <maheshp@posedge.com>
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Wed, 20 Mar 2013 09:16:16 +0530
In-Reply-To: <20130319122836.GA26078@magnum.frso.rivierawaves.com>
References: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
	 <1363652600-23223-2-git-send-email-karl.beldan@gmail.com>
	 <1363693626.3355.14.camel@WLAN-SW-TEST-03>
	 <20130319122836.GA26078@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 13:28 +0100, Karl Beldan wrote:
> On Tue, Mar 19, 2013 at 05:17:06PM +0530, Mahesh Palivela wrote:
> > On Tue, 2013-03-19 at 01:23 +0100, Karl Beldan wrote:
> > > From: Karl Beldan <karl.beldan@rivierawaves.com>

> > > +	local->_oper_chandef.center_freq1 += cfreq_off;
> > > +	local->_oper_chandef.center_freq2 += cfreq_off;
> > 
> > can't add cfreq_off to center_freq2. Add only in case of non-zero
> > center_freq2?
> > 
> At first I was like "why ?", but I hadn't spotted the places where we
> only check for "center_freq2 != 0".
> 
> 
> Thanks Mahesh, Have you tested vht with this ? 

Not yet Karl. I will give it a try and update you.

Thanks,
Mahesh

