Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:40610 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934115Ab2FENde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 09:33:34 -0400
Message-ID: <1338903211.3277.1.camel@joe2Laptop> (sfid-20120605_153337_923396_06051E52)
Subject: Re: [PATCH] wireless: add my new trees to MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jun 2012 06:33:31 -0700
In-Reply-To: <1338898901.4514.40.camel@jlt3.sipsolutions.net>
References: <1338898901.4514.40.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-05 at 14:21 +0200, Johannes Berg wrote:
> Add my new trees to the MAINTAINERS file
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -5694,6 +5699,10 @@ F:	include/linux/remoteproc.h
>  
>  RFKILL
>  M:	Johannes Berg <johannes@sipsolutions.net>
> +W:	http://wireless.kernel.org/
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
> +S:	Maintained
>  L:	linux-wireless@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/rfkill.txt

no need for multiple S: lines

