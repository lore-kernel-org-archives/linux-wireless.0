Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39384 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178AbaLWP6k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 10:58:40 -0500
Message-ID: <1419350316.6091.9.camel@sipsolutions.net> (sfid-20141223_165843_074848_89CDC23F)
Subject: Re: [PATCH] cfg80211: add extensible feature flag attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 23 Dec 2014 16:58:36 +0100
In-Reply-To: <1419350119-29166-1-git-send-email-arend@broadcom.com>
References: <1419350119-29166-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-23 at 16:55 +0100, Arend van Spriel wrote:
> From: Gautam Kumar Shukla <gautams@broadcom.com>
> 
> With the wiphy::features flag being used up this patch adds a
> new field wiphy::ext_features. Considering extensibility this
> new field is declared as a byte array. This extensible flag is
> exposed to user-space by NL80211_ATTR_EXT_FEATURES.

Ah, I guess this will compile without even any flags defined, so
Avinash, you can just build on top of this and define the first flag,
and for the sake of attribution I'll apply it as two separate patches.

Thanks Arend.

johannes

