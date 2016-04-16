Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60410 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbcDPWXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 18:23:07 -0400
Message-ID: <1460845384.2075.27.camel@sipsolutions.net> (sfid-20160417_002312_882340_E3C446AE)
Subject: Re: [PATCHv3 2/5] mac80211: implement fair queueing per txq
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: dave.taht@gmail.com, make-wifi-fast@lists.bufferbloat.net,
	codel@lists.bufferbloat.net, apenwarr@gmail.com
Date: Sun, 17 Apr 2016 00:23:04 +0200
In-Reply-To: <1460636302-31161-3-git-send-email-michal.kazior@tieto.com> (sfid-20160414_141630_431218_2C3B49F3)
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160414_141630_431218_2C3B49F3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-04-14 at 14:18 +0200, Michal Kazior wrote:
> 
> +++ b/net/mac80211/fq.h
> 
Now that you've mostly rewritten it, why keep it in a .h file?

johannes
