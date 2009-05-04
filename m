Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50237 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122AbZEDQlE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:41:04 -0400
Message-ID: <49FF1A9B.9000608@openwrt.org>
Date: Mon, 04 May 2009 18:40:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby wrote:
> minstrel doesn't count max rate count in fact, since it doesn't use
> a loop variable `i' and hence allocs space only for bitrates found in
> the first band.
> 
> Fix it by involving the `i' as an index so that it traverses all the
> bands now and finds the real max bitrate count.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Felix Fietkau <nbd@openwrt.org>
Good catch!

Acked-by: Felix Fietkau <nbd@openwrt.org>
