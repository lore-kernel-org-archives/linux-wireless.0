Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38212 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaLQUVs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 15:21:48 -0500
Message-ID: <1418847703.2135.28.camel@sipsolutions.net> (sfid-20141217_212151_791893_C71A3A27)
Subject: Re: nl80211 feature flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 17 Dec 2014 21:21:43 +0100
In-Reply-To: <5491E256.40302@broadcom.com>
References: <5491E256.40302@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-17 at 21:06 +0100, Arend van Spriel wrote:

> I intended to add a feature flag, but it seems filled up completely on 
> mac80211-next tree. Did you already have an idea how to extend this?

Yeah, I noticed that before, but I didn't have a plan yet.

I think since the features are documented as a u32 attribute we can't
extend them very well. I think we probably have to add another attribute
- but maybe we should define the new one as a u8 array or so to begin
with (like e.g. the extended capabilities information element)

johannes

