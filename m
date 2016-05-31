Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40555 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbcEaKOf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 06:14:35 -0400
Message-ID: <1464689672.3076.11.camel@sipsolutions.net> (sfid-20160531_121438_658103_63BAD29E)
Subject: Re: [PATCH] mac80211: fix fast_tx header alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Tue, 31 May 2016 12:14:32 +0200
In-Reply-To: <1463672078-7982-1-git-send-email-nbd@nbd.name>
References: <1463672078-7982-1-git-send-email-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-05-19 at 17:34 +0200, Felix Fietkau wrote:
> The header field is defined as u8[] but also accessed as struct
> ieee80211_hdr. Enforce an alignment of 2 to prevent unnecessary
> unaligned accesses, which can be very harmful for performance on many
> platforms.
> 
> 
Applied, thanks.

johannes
