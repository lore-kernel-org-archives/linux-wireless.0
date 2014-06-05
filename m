Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37976 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaFEM3u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 08:29:50 -0400
Message-ID: <1401971372.4168.0.camel@jlt4.sipsolutions.net> (sfid-20140605_143000_886297_5FF9785F)
Subject: Re: [PATCH v2] mac80211: allow tx via monitor iface when DFS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Jun 2014 14:29:32 +0200
In-Reply-To: <1401948777-3262-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140605_081323_512048_6A292FA1)
References: <1401948777-3262-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140605_081323_512048_6A292FA1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-06-05 at 08:12 +0200, Janusz Dziedzic wrote:
> Allow send frames using monitor interface
> when DFS chandef and we pass CAC (beaconing
> allowed).
> 
> This fix problem when old kernel and new backports used,
> in such case hostapd create/use also monitor interface.
> Before this patch all frames hostapd send using monitor
> iface were dropped when AP was configured on DFS channel.

Applied.

johannes

