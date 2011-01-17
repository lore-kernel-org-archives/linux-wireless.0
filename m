Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1AQLNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 06:13:05 -0500
Subject: Re: Merging SSB and HND/AI support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: Jonas Gorski <jonas.gorski@gmail.com>, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1295261783.24530.3.camel@maggie>
References: <AANLkTi=GDcy50zsC6=Dgv1-Ty3cYK2qpx9o=q3JdXuCh@mail.gmail.com>
	 (sfid-20110117_114654_053644_FFFFFFFF84F9C750)  <1295261783.24530.3.camel@maggie>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 12:13:01 +0100
Message-ID: <1295262781.3726.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 11:56 +0100, Michael Büsch wrote:

> > As far as I can see, there are two possibilities:
> > 
> > a) Merge the HND/AI code into the current SSB code, or
> > 
> > b) add the missing code for SoCs to brcm80211 and replace the SSB code with it.
> 
> Why can't we keep those two platforms separated?
> Is there really a lot of shared code between SSB and HND/AI?

I don't think there's a lot of shared code, but I believe that you need
b43 to be able to target cores on both? And b43 currently uses the SSB
APIs only.

johannes

