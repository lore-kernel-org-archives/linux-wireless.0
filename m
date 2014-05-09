Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51277 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbaEIIjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 04:39:12 -0400
Message-ID: <1399624749.4136.2.camel@jlt4.sipsolutions.net> (sfid-20140509_103917_654217_84221CCB)
Subject: Re: [PATCH] mac80211: don't downgrade VHT20 to HT20
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 09 May 2014 10:39:09 +0200
In-Reply-To: <1393327628-1078-1-git-send-email-michal.kazior@tieto.com> (sfid-20140225_123231_872299_347E9F99)
References: <1393327628-1078-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140225_123231_872299_347E9F99)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 12:27 +0100, Michal Kazior wrote:
> The check led to VHT-capable devices being unable
> to pair in VHT20 and were instead paired in HT20.
> 
> This improves throughput for VHT20 pairing.

We also found this same issue in client mode - some APs have the same
issue and don't set the flag correctly.

I'm writing the same patch with some comments now, as a combination of
this and another patch we had internally.

johannes

