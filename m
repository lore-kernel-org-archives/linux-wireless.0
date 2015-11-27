Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44674 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbbK0IZL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:25:11 -0500
Message-ID: <1448612707.2531.1.camel@sipsolutions.net> (sfid-20151127_092514_336879_1A8A3DBC)
Subject: Re: [PATCH v2 7/8] cfg80211: Add Kconfig option for ITS-G5 band
 (5.9 GHz)
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Sojka <sojkam1@fel.cvut.cz>, linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Jan =?ISO-8859-1?Q?Kaisrl=EDk?= <kaisrja1@fel.cvut.cz>
Date: Fri, 27 Nov 2015 09:25:07 +0100
In-Reply-To: <87d1uw31r1.fsf@steelpick.2x.cz>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
	 <1448303241-27747-8-git-send-email-sojkam1@fel.cvut.cz>
	 <1448560529.2167.43.camel@sipsolutions.net>
	 <87d1uw31r1.fsf@steelpick.2x.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-26 at 22:10 +0100, Michal Sojka wrote:
> 
> Because in [1] Jouni said that
> 
>    "kernel config option + custom regdb would certainly be much
> closer to what I'd like to see from the regulatory enforcement view
> point"
> 
> I also like the fact that the help text mentions the relevant
> regulatory documents. I guess the users would appreciate that.
> 

Fair enough, but I'm not really convinced that the Kconfig option is
needed for what Jouni really required.

In any case, I spoke with him yesterday and we don't think that your
patches are going to work as is - we'll need to change the regulatory
flags it seems. I'll comment more specifically on the patches.

johannes
