Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34058 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467AbbCRUXi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 16:23:38 -0400
Message-ID: <1426710215.3001.43.camel@sipsolutions.net> (sfid-20150318_212343_042983_0C8F3D2D)
Subject: Re: [PATCH v4] mac80211: add an intermediate software queue
 implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 18 Mar 2015 21:23:35 +0100
In-Reply-To: <5509DDAF.80706@openwrt.org>
References: <1426609283-83954-1-git-send-email-nbd@openwrt.org>
		 <1426707672.3001.39.camel@sipsolutions.net> <5509DA00.6030002@openwrt.org>
	 <1426709222.3001.42.camel@sipsolutions.net> <5509DDAF.80706@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-18 at 21:18 +0100, Felix Fietkau wrote:

> > Anyway - not sure it needs to be in the callback?
> I think it makes things simpler this way. What would you prefer?

It might for the driver, but I'm not sure it should be required and
described in the docs?

johannes

