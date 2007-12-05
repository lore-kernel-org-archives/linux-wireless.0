Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:48963 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751442AbXLELMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 06:12:38 -0500
Date: Wed, 5 Dec 2007 12:07:52 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: make drivers include the TSF RX flag where
 appropriate
Message-ID: <20071205120752.7fb040b8@morte> (sfid-20071205_111243_937725_1B058DFD)
In-Reply-To: <1196796820.12472.1.camel@johannes.berg>
References: <1196796820.12472.1.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 04 Dec 2007 20:33:40 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> --- everything.orig/drivers/net/wireless/b43legacy/xmit.c
> 2007-12-04 20:32:32.076950086 +0100 +++
> everything/drivers/net/wireless/b43legacy/xmit.c	2007-12-04
> 20:33:13.996951714 +0100 @@ -548,6 +548,7 @@ void b43legacy_rx(struct
> b43legacy_wldev status.mactime += mactime; if (low_mactime_now <= mactime)
>  			status.mactime -= 0x10000;
> +		status.flag |= RX_FLAG_TSFT;
>  	}

Acked-by: Stefano Brivio <stefano.brivio@polimi.it>


-- 
Ciao
Stefano
