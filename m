Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1650 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab1LOLpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 06:45:34 -0500
Message-ID: <4EE9DDD2.3000904@broadcom.com> (sfid-20111215_124538_029239_79950BB0)
Date: Thu, 15 Dec 2011 12:45:22 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "John W Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: Replace kmalloc/memset with kzalloc
References: <4ee95a07.ADXjXEI3nOhhruq1%Larry.Finger@lwfinger.net>
In-Reply-To: <4ee95a07.ADXjXEI3nOhhruq1%Larry.Finger@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2011 03:23 AM, Larry Finger wrote:
> In ai_attach(), space is allocated for an si_info struct. Immediately
> after the allocation, routine ai_doattach() is called and that allocated
> space is set to zero. As no other routine calls ai_doattach(), kzalloc()
> can be utilized.
> 

Acked-by: Arend van Spriel <arend@broadcom.com>

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This is 3.3 material.
> 
> Larry

Thanks, Larry

Gr. AvS

