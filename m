Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0JFTTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 15:19:09 -0400
Subject: Re: Crash in cfg80211_unlink_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hun-Kyi Wynn <hkwynn@candelatech.com>
In-Reply-To: <4CACCA98.7010204@candelatech.com>
References: <4CACB1D1.7090900@candelatech.com>
	 <1286388245.3655.392.camel@jlt3.sipsolutions.net>
	 <4CACBB14.1090507@candelatech.com>
	 <1286388980.3655.395.camel@jlt3.sipsolutions.net>
	 <4CACCA98.7010204@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 21:19:09 +0200
Message-ID: <1286392749.3655.411.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 12:14 -0700, Ben Greear wrote:
> On 10/06/2010 11:16 AM, Johannes Berg wrote:
> > On Wed, 2010-10-06 at 11:08 -0700, Ben Greear wrote:
> >
> >>> I need to analyse the refcounting here again and in more detail, but in
> >>> the meantime can you try below patch?
> >>
> >> Yes, will do so and let you know the results.
> >
> > Please try the new version, and let me know. I should submit this ASAP.
> 
> That patch seems to fix things.
> 
> Feel free to add:  Tested-by: Hun-Kyi Wynn <hkwynn@candelatech.com>

Thanks, I've sent out the patch.

johannes

