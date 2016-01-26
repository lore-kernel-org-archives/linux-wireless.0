Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39539 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964860AbcAZM4W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 07:56:22 -0500
Message-ID: <1453812978.2759.39.camel@sipsolutions.net> (sfid-20160126_135625_445583_DADDEC70)
Subject: Re: [PATCH 2/2] mac80211: expose txq queue depth and size to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jan 2016 13:56:18 +0100
In-Reply-To: <CA+BoTQk+7cpP9jZ8UyUjOrnPc309LdgYN8BbNBfEOyTSUDBcAw@mail.gmail.com> (sfid-20160126_125632_766789_63408298)
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
	 <1453382588-27105-2-git-send-email-michal.kazior@tieto.com>
	 <56A74E51.80609@openwrt.org>
	 <CA+BoTQk+7cpP9jZ8UyUjOrnPc309LdgYN8BbNBfEOyTSUDBcAw@mail.gmail.com>
	 (sfid-20160126_125632_766789_63408298)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I don't see a point in maintaining coherency between the two counters
> with regard to each other alone. Do you have a use-case that would
> actually make use of that property?
> 
> I'd like to avoid any unnecessary spinlocks.
> 

Make sure you document the lack of consistency between the two values
then, please.

johannes
