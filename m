Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nexus.dynaweb.hu ([195.70.37.87]:43976 "EHLO nexus.dynaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbYKMW7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 17:59:30 -0500
Date: Thu, 13 Nov 2008 23:59:28 +0100
From: RUMI Szabolcs <rumi_ml@rtfm.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
Message-Id: <20081113235928.3ed79ff6.rumi_ml@rtfm.hu> (sfid-20081113_235941_810109_7B5C345C)
In-Reply-To: <1226598550.5839.3.camel@johannes.berg>
References: <20081112224810.8d4ca179.rumi_ml@rtfm.hu>
	<1226530010.15173.0.camel@dv>
	<20081113004632.d8d821c5.rumi_ml@rtfm.hu>
	<20081113181155.c556bde1.rumi_ml@rtfm.hu>
	<1226598550.5839.3.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 13 Nov 2008 18:49:10 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> > I have compiled a kernel from wireless-testing git of today (2.6.28-rc4-wl)
> > then recompiled and tested hostapd-0.6.5 against that,
> 
> look, you need hostapd from git

If you look a bit further down in that email, I've also tried
exactly that afterwards but unfortunately it made no difference.

BTW I've made a diff -rduN between hostapd-0.6.5 and todays -git
but haven't spotted anything relevant to my problem anyway.

To summarize:

2.6.27 + hostapd-0.6.5 = NO
2.6.27 + OpenWRT hack + hostapd-0.6.5 = NO
compat-wireless-2008-11-12 + hostapd-0.6.5 = NO
wireless-testing-git + hostapd-0.6.5 = NO
wireless-testing-git + hostapd-git = NO

In fact I've also tried hostapd-0.6.4 and 0.5.10 at some point
but they didn't make anything better.

Thanks,

Sab
