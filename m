Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59866 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbcBWMQo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 07:16:44 -0500
Message-ID: <1456229801.9910.0.camel@sipsolutions.net> (sfid-20160223_131649_633935_893A1B05)
Subject: Re: [PATCH 1/2] mac80211: add A-MSDU tx support
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Cc: egrumbach@gmail.com
Date: Tue, 23 Feb 2016 13:16:41 +0100
In-Reply-To: <1455820762-22876-1-git-send-email-nbd@openwrt.org> (sfid-20160218_212037_356657_E24E9177)
References: <1455820762-22876-1-git-send-email-nbd@openwrt.org>
	 (sfid-20160218_212037_356657_E24E9177)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-18 at 19:39 +0100, Felix Fietkau wrote:
> Requires software tx queueing support. frag_list support (for zero-
> copy)
> is optional.
> 
Come to think of it, a commit message that explains what it does and
how it works would be nice :)

johannes
