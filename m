Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:51320 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129AbYHDTrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 15:47:04 -0400
Date: Mon, 4 Aug 2008 15:45:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: Johannes Berg <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: one remaining unused CONFIG variable under net/
In-Reply-To: <1217877394.3603.5.camel@johannes.berg>
Message-ID: <alpine.LFD.1.10.0808041522090.17521@localhost.localdomain> (sfid-20080804_214711_930945_80E4F6B2)
References: <alpine.LFD.1.10.0808041508070.11910@localhost.localdomain>  (sfid-20080804_211117_795474_92E803F8) <1217877394.3603.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 4 Aug 2008, Johannes Berg wrote:

> On Mon, 2008-08-04 at 15:09 -0400, Robert P. J. Day wrote:
> > this is the single remaining CONFIG variable under the net/
> > directory that is currently unreferenced.
> >
> > ===== MAC80211_VERBOSE_SPECT_MGMT_DEBUG
> > net/mac80211/Kconfig:206:config MAC80211_VERBOSE_SPECT_MGMT_DEBUG
>
> Yeah, it'll be used though; it was added in an early patch of the
> spectrum management code, then that got delayed by some confusion
> over a requisite patch and now Tomas wants to redraw that one too...
> Don't worry about it, I'll be keeping an eye on it.

i suspected as much, but i thought i'd mention it anyway.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
