Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49872 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926Ab3DILZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 07:25:10 -0400
Received: by mail-wg0-f48.google.com with SMTP id m15so6677167wgh.15
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2013 04:25:09 -0700 (PDT)
Date: Tue, 9 Apr 2013 13:21:20 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: always pick a basic rate to tx RTS/CTS for
 pre-HT rates
Message-ID: <20130409112120.GC27875@magnum.frso.rivierawaves.com> (sfid-20130409_132518_736625_8E43E88F)
References: <1365156384-6699-1-git-send-email-karl.beldan@gmail.com>
 <1365503356.8465.37.camel@jlt4.sipsolutions.net>
 <20130409105535.GA27875@magnum.frso.rivierawaves.com>
 <1365505512.8465.40.camel@jlt4.sipsolutions.net>
 <20130409111028.GB27875@magnum.frso.rivierawaves.com>
 <1365506215.8465.41.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1365506215.8465.41.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 09, 2013 at 01:16:55PM +0200, Johannes Berg wrote:
> On Tue, 2013-04-09 at 13:10 +0200, Karl Beldan wrote:
> 
> > > Oh, oops, confused. But then you look at 9.7.6.2 "Rate selection for
> > > control frames that initiate a TXOP", which just mandates that you use
> > > any rate that the receiver supports, so why bother doing basic rates
> > > etc. at all?
> > > 
> > 
> > This chapter precisely, however it reads:
> > {
> > "If a control frame other than a Basic BlockAckReq or Basic BlockAck is
> > carried in a non-HT PPDU, the transmitting STA shall transmit the frame
> > using one of the rates in the BSSBasicRateSet parameter or a rate from
> > the mandatory rate set of the attached PHY if the BSSBasicRateSet is
> > empty."
> > }
> 
> Oh, right. I'll review the patch again I guess :-)
> 

Ok, thanks.
 
Karl
