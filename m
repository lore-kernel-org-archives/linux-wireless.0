Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.dnainternet.fi ([87.94.96.112]:51660 "EHLO
	smtp2.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYEZUrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 16:47:40 -0400
Message-ID: <20080526234737.eye44fzzk04wo8ks@hayate.ip6> (sfid-20080526_224748_853167_401BA78B)
Date: Mon, 26 May 2008 23:47:37 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Scott Ashcroft <scott.ashcroft@talk21.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rndis_wlan: Make connections to TKIP PSK networks work
References: <20080524193608.GB29429@backup.qzxyz.com>
In-Reply-To: <20080524193608.GB29429@backup.qzxyz.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Scott Ashcroft <scott.ashcroft@talk21.com>:

> This patch allows the rndis_wlan driver to connect to TKIP PSK networks.
> It uses the ASSOCIATION_INFORMATION RNDIS call to pull back the IEs   
> and sends them back to userspace using wireless events.
> Tested on a few wireless networks I have access to.
> Based on the similar code in ndiswrapper.
>
> Cheers,
> Scott
>

Thanks, this patch fixed my tkip problems with broadcom/openwrt box. I  
made small cleanups to the patch and will be sending it soon.

  - Jussi


