Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50428 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0CQCQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 22:16:44 -0400
Subject: Re: [RFC] cfg80211: Add local-state-change-only
 auth/deauth/disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100317021338.GA5654@jm.kir.nu>
References: <20100313195335.GA2420@jm.kir.nu>
	 <1268777894.8918.13.camel@jlt3.sipsolutions.net>
	 <20100317021338.GA5654@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 19:16:37 -0700
Message-ID: <1268792197.7068.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-16 at 19:13 -0700, Jouni Malinen wrote:
> On Tue, Mar 16, 2010 at 03:18:14PM -0700, Johannes Berg wrote:
> > mac80211 no longer maintains auth state at all when the auth is not in
> > process, so should we, instead of passing this all through mac80211,
> > make it cfg80211-only? Ok that doesn't work for the assoc part, but for
> > auth it should?
> 
> I thought about that a bit when going through the needed changes and the
> question of what to do with key configuration before association.. If we
> want to enable that optimization, we will likely need to notify mac80211
> somehow and this auth part could indeed be that notification. Or did you
> have some other ways in mind for getting keys configured
> pre-association?

Ah, that's a good point. No, I hadn't really thought about the
implications yet.

johannes

