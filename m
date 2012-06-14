Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2973 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab2FNMym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 08:54:42 -0400
Message-ID: <4FD9DF08.4020304@broadcom.com> (sfid-20120614_145446_236922_5E53026F)
Date: Thu, 14 Jun 2012 14:54:32 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Arend van Spriel" <arend@broadcom.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] brcmfmac: introduce checkdied debugfs
 functionality
References: <1339669017-13388-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1339669017-13388-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/14/2012 12:16 PM, Arend van Spriel wrote:
> The checkdied functionality provides useful information for analyzing
> firmware crashes. By exposing this information to a debugfs file users
> can easily provide its content in bug reports. The functionality is
> available only when CONFIG_BRCMDBG is selected.
> 
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> This patch changes kzalloc() to vzalloc(). This replaces patch with
> message-id <1339275105-3593-6-git-send-email-arend@broadcom.com>.
> 
> All 5 patches apply to latest wireless-next/master branch.

Hi John,

Just fetched wireless-next and noticed you already applied the first 4
patches. I tried and this fifth patch does apply to wireless-next/master.

Gr. AvS

