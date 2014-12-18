Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41477 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaLRNbn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 08:31:43 -0500
Message-ID: <1418909497.6134.5.camel@sipsolutions.net> (sfid-20141218_143146_758266_6408EF9E)
Subject: Re: [RFC] cfg80211: Add feature flag for 4-way handshake offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Date: Thu, 18 Dec 2014 14:31:37 +0100
In-Reply-To: <1418907095-10224-1-git-send-email-arend@broadcom.com>
References: <1418907095-10224-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-12-18 at 13:51 +0100, Arend van Spriel wrote:

> Here the proposed way to deal with new feature flags. Let
> me know if this is suitable.

I guess that works. I think those functions should be inlines - no point
in having them with export symbol etc (the structures needed for that
are *far* bigger than the functions.)

johannes


