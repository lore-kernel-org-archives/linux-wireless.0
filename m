Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25722 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0IHRmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 13:42:24 -0400
Subject: Re: [PATCH v1 8/8] wireless: wl1271_sdio: enable Runtime PM
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>
In-Reply-To: <1283858949-11073-9-git-send-email-ohad@wizery.com>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com>
	 <1283858949-11073-9-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 10:40:23 -0700
Message-ID: <1283967623.9120.13.camel@capsicum>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-07 at 13:29 +0200, ext Ohad Ben-Cohen wrote:
> Enable runtime pm for the wl1271 SDIO device.
> 
> We request power whenever the WLAN interface is brought up,
> and release it after the WLAN interface is taken down.
> 
> As a result, power is released immediately after probe returns,
> since at that point power has not been explicitly requested yet
> (i.e. the WLAN interface is still down).
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Looks fine to me, after considering David's comment and since it's done
in the same way for PCI.

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>


-- 
Cheers,
Luca.

