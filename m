Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53199 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbbCQKGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 06:06:02 -0400
Message-ID: <1426586759.1985.7.camel@sipsolutions.net> (sfid-20150317_110611_954575_F6CEBA1F)
Subject: Re: [PATCHv2 1/3] mac80211: IBSS fix scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Mar 2015 11:05:59 +0100
In-Reply-To: <1425884296-7074-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150309_075906_614303_1DAFDDED)
References: <1425884296-7074-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150309_075906_614303_1DAFDDED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-09 at 07:58 +0100, Janusz Dziedzic wrote:
> In case of wide bandwidth scan all channels we have
> in chandef. For example in case of 80MHz bandwidth
> we have four possible control channels.

I think you misunderstood - this doesn't really say *why* either.

It should probably say something like

If channels wider than 20 MHz are used by IBSS, scan all channels in the
chandef to be able to find neighboring IBSS networks that use the same
overall channel but a different control channel.

no?

johannes

