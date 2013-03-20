Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36645 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab3CTMdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 08:33:16 -0400
Received: by mail-wi0-f176.google.com with SMTP id hm14so5205960wib.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 05:33:15 -0700 (PDT)
Date: Wed, 20 Mar 2013 13:29:56 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [RFC V2 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
Message-ID: <20130320122956.GA12516@magnum.frso.rivierawaves.com> (sfid-20130320_133320_776484_645BD439)
References: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
 <1363652600-23223-2-git-send-email-karl.beldan@gmail.com>
 <1363693626.3355.14.camel@WLAN-SW-TEST-03>
 <20130319122836.GA26078@magnum.frso.rivierawaves.com>
 <1363751176.9344.1.camel@WLAN-SW-TEST-03>
 <1363776796.9344.14.camel@WLAN-SW-TEST-03>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363776796.9344.14.camel@WLAN-SW-TEST-03>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 20, 2013 at 04:23:16PM +0530, Mahesh Palivela wrote:
> On Wed, 2013-03-20 at 09:16 +0530, Mahesh Palivela wrote:
> > On Tue, 2013-03-19 at 13:28 +0100, Karl Beldan wrote:
> > > On Tue, Mar 19, 2013 at 05:17:06PM +0530, Mahesh Palivela wrote:
> > > > On Tue, 2013-03-19 at 01:23 +0100, Karl Beldan wrote:
> > > > > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > > > > +	local->_oper_chandef.center_freq1 += cfreq_off;
> > > > > +	local->_oper_chandef.center_freq2 += cfreq_off;
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
