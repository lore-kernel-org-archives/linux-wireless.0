Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54203 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbcA1JrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 04:47:06 -0500
Message-ID: <1453974422.2217.1.camel@sipsolutions.net> (sfid-20160128_104711_661882_FEAAE537)
Subject: Re: [PATCH] net/mac80211/agg-rx.c: fix use of uninitialised values
From: Johannes Berg <johannes@sipsolutions.net>
To: Chris Bainbridge <chris.bainbridge@gmail.com>,
	linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, aryabinin@virtuozzo.com
Date: Thu, 28 Jan 2016 10:47:02 +0100
In-Reply-To: <20160127154618.GA5717@localhost> (sfid-20160127_164628_730126_88BF58E3)
References: <20160126111730.GA6765@localhost>
	 <20160127154618.GA5717@localhost> (sfid-20160127_164628_730126_88BF58E3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 15:46 +0000, Chris Bainbridge wrote:
> Use kzalloc instead of kmalloc for struct tid_ampdu_rx. Fixes:
> 
Applied, thanks.

johannes
