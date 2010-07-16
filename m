Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48614 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964971Ab0GPKpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 06:45:50 -0400
Message-ID: <4C403859.70201@openwrt.org>
Date: Fri, 16 Jul 2010 12:45:45 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: Re: what's the status of ATHEROS_AR71XX config variable?
References: <alpine.DEB.2.00.1007160440530.13924@lynx>
In-Reply-To: <alpine.DEB.2.00.1007160440530.13924@lynx>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-16 10:43 AM, Robert P. J. Day wrote:
> 
>   from drivers/net/wireless/ath/ath9k/Makefile:
> 
> ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
> 
> but there is no such config variable.  so i'm thinking *something*
> should be removed.
The platform port for AR71xx hasn't been submitted upstream yet. But the
code in ahb.c is actively being used in OpenWrt.

I don't know what the status on submitting the code to linux-mips is,
but I've Cc'd Gabor, he should know ;)

- Felix
