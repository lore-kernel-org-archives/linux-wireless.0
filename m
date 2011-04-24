Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50970 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab1DXTOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 15:14:52 -0400
Received: by wya21 with SMTP id 21so1224296wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 12:14:51 -0700 (PDT)
Subject: Re: [PATCH v2] 802.11n frame injection
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Matteo Croce <matteo@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1303632949.3795.7.camel@jlt3.sipsolutions.net>
References: <BANLkTikBEs7aWZR+UovtpwYVPJfZjHEhgw@mail.gmail.com>
	 <1303632949.3795.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 22:14:44 +0300
Message-ID: <1303672484.14128.2.camel@maxim-laptop> (sfid-20110424_211503_603812_762D5F8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-24 at 10:15 +0200, Johannes Berg wrote:
> On Fri, 2011-04-22 at 18:34 +0200, Matteo Croce wrote:
> > This patch allows to set the tx rate and retries when injecting,
> > and report correct MCS information on received frames.
> 
> This description is wrong. It doesn't touch rx.c, does it?

It does appear to touch radiotap processing, and I bet the developer
tested this, but other than that don't know.

> 
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Best regards,
        Maxim Levitsky

Visit my blog: http://maximlevitsky.wordpress.com
Warning: Above blog contains rants.

