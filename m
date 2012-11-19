Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2703 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab2KSSsi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:48:38 -0500
Message-ID: <50AA7ED9.6030803@broadcom.com> (sfid-20121119_194841_094180_794E6477)
Date: Mon, 19 Nov 2012 19:47:53 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	"Daniel Wagner" <wagi@monom.org>
Subject: Re: [PATCH v2 08/22] brcmsmac: Reduce number of entries in tx
 DMA rings
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-9-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1352988492-21340-9-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2012 03:07 PM, Seth Forshee wrote:
> Currently up to 256 frames can be queued for each DMA ring. This is
> excessive, and now that we have better flow control we can get by with
> less. Experimentation has shown 64 to work well.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/main.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)


