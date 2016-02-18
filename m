Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45250 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946394AbcBRUYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 15:24:45 -0500
Message-ID: <1455827082.2084.28.camel@sipsolutions.net> (sfid-20160218_212450_108389_E7F7A285)
Subject: Re: [RFC 1/2] cfg80211: add radiotap VHT info to
 rtap_namespace_sizes
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 18 Feb 2016 21:24:42 +0100
In-Reply-To: <1455121877-7238-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160210_173120_797372_428D9791)
References: <1455121877-7238-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1455121877-7238-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20160210_173120_797372_428D9791)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-10 at 17:31 +0100, Lorenzo Bianconi wrote:
> Add IEEE80211_RADIOTAP_VHT entry to rtap_namespace_sizes array in
> order to
> define alignment and size of VHT info in tx radiotap
> 
I think you forgot this patch in your [PATCH] resend, can you resend it
properly?

johannes
