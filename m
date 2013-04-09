Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab3DILRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 07:17:00 -0400
Message-ID: <1365506215.8465.41.camel@jlt4.sipsolutions.net> (sfid-20130409_131705_977206_E78DF9FC)
Subject: Re: [PATCH] mac80211: always pick a basic rate to tx RTS/CTS for
 pre-HT rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Tue, 09 Apr 2013 13:16:55 +0200
In-Reply-To: <20130409111028.GB27875@magnum.frso.rivierawaves.com> (sfid-20130409_131418_369760_89FEFF28)
References: <1365156384-6699-1-git-send-email-karl.beldan@gmail.com>
	 <1365503356.8465.37.camel@jlt4.sipsolutions.net>
	 <20130409105535.GA27875@magnum.frso.rivierawaves.com>
	 <1365505512.8465.40.camel@jlt4.sipsolutions.net>
	 <20130409111028.GB27875@magnum.frso.rivierawaves.com>
	 (sfid-20130409_131418_369760_89FEFF28)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-09 at 13:10 +0200, Karl Beldan wrote:

> > Oh, oops, confused. But then you look at 9.7.6.2 "Rate selection for
> > control frames that initiate a TXOP", which just mandates that you use
> > any rate that the receiver supports, so why bother doing basic rates
> > etc. at all?
> > 
> 
> This chapter precisely, however it reads:
> {
> "If a control frame other than a Basic BlockAckReq or Basic BlockAck is
> carried in a non-HT PPDU, the transmitting STA shall transmit the frame
> using one of the rates in the BSSBasicRateSet parameter or a rate from
> the mandatory rate set of the attached PHY if the BSSBasicRateSet is
> empty."
> }

Oh, right. I'll review the patch again I guess :-)

johannes

