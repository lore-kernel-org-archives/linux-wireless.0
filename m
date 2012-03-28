Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2C1Mte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 08:49:34 -0400
Message-ID: <1332938972.3479.34.camel@jlt3.sipsolutions.net> (sfid-20120328_144949_654989_A27CC6DF)
Subject: Re: [RFC 0/2] mac80211 queue redesign
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 28 Mar 2012 14:49:32 +0200
In-Reply-To: <1332936021.3479.33.camel@jlt3.sipsolutions.net> (sfid-20120328_140031_911935_3F0F935C)
References: <20120328091346.442543219@sipsolutions.net>
	 (sfid-20120328_111858_724256_2CFB2788) <1332936021.3479.33.camel@jlt3.sipsolutions.net>
	 (sfid-20120328_140031_911935_3F0F935C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-28 at 14:00 +0200, Johannes Berg wrote:
> On Wed, 2012-03-28 at 11:13 +0200, Johannes Berg wrote:
> 
> > The monitor feature I've tested in hwsim, it works. The
> > queue feature isn't tested at all, I haven't even done
> > any kind of regression tests for drivers not using it.
> 
> I ran some regression testing now and it seems to work. Haven't tested
> the new features yet though.

Woot. I started testing now with a modified iwlwifi and found no bugs so
far :-)

I did add three minor improvements, but those just aid debugging...

johannes

