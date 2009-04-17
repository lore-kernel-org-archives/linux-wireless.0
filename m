Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f126.google.com ([209.85.221.126]:37524 "EHLO
	mail-qy0-f126.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZDQTa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 15:30:26 -0400
Received: by qyk32 with SMTP id 32so93777qyk.33
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2009 12:30:24 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18920.55219.833341.713847@gargle.gargle.HOWL> (sfid-20090417_213028_319909_BFB15063)
Date: Sat, 18 Apr 2009 00:55:39 +0530
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] iw: Add set/get for frag/rts threshold and retry limits
In-Reply-To: <20090417185041.GA17526@jm.kir.nu>
References: <20090417185041.GA17526@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> --- iw.orig/nl80211.h	2009-04-17 21:48:13.000000000 +0300
> +++ iw/nl80211.h	2009-04-17 21:48:17.000000000 +0300
> @@ -7,7 +7,7 @@
>   * Copyright 2008 Michael Wu <flamingice@sourmilk.net>
>   * Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
>   * Copyright 2008 Michael Buesch <mb@bu3sch.de>
> - * Copyright 2008 Luis R. Rodriguez <lrodriguez@atheros.com>
> + * Copyright 2008, 2009 Luis R. Rodriguez <lrodriguez@atheros.com>
>   * Copyright 2008 Jouni Malinen <jouni.malinen@atheros.com>
>   * Copyright 2008 Colin McCabe <colin@cozybit.com>

I don't think Luis would complain, but still... :-)

Sujith
