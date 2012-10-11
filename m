Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205Ab2JKTdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 15:33:47 -0400
Message-ID: <1349984058.13097.17.camel@jlt4.sipsolutions.net> (sfid-20121011_213352_028287_37C4D2FB)
Subject: Re: [RFC] wireless: cfg80211: add peer-to-peer related definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Oct 2012 21:34:18 +0200
In-Reply-To: <50770A50.3010305@broadcom.com>
References: <1349965104-14475-1-git-send-email-arend@broadcom.com>
	 <1349973674.13097.11.camel@jlt4.sipsolutions.net>
	 <5077008D.7030203@broadcom.com>
	 <1349976385.13097.13.camel@jlt4.sipsolutions.net>
	 <50770A50.3010305@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-11 at 20:05 +0200, Arend van Spriel wrote:

> > Ah, fmac, that will be somewhat interesting. What userspace APIs are you
> > proposing for that case?

> Not sure if I understand the question. I am using wpa_supplicant with 
> wpa_cli for testing and given its p2p support I assumed there is already 
> a nl80211 api in place. I am still trying to get a good sense on it. The 
> P2P code to port does more parsing of P2P stuff and if you mean adding 
> userspace APIs to avoid just that I would definitely prefer that.

Well the APIs that we have in place right now are really basically just
a conduit and wpa_s does all the operations. I would expect fmac to have
more offloads (and thus need the parsing), I'd actually be surprised if
you could work with the existing APIs.

johannes

