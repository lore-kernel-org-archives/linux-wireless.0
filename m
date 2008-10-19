Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:36866 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbYJSOaf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 10:30:35 -0400
Date: Sun, 19 Oct 2008 17:29:38 +0300
From: Jouni Malinen <j@w1.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] hostap: Fix sparse warnings
Message-ID: <20081019142938.GC4867@jm.kir.nu> (sfid-20081019_163041_614359_B75A8FEF)
References: <48F761C1.9000109@lwfinger.net> <48F7D1C3.20900@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48F7D1C3.20900@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 16, 2008 at 04:44:03PM -0700, Larry Finger wrote:

>   CHECK   drivers/net/wireless/hostap/hostap_info.c
> drivers/net/wireless/hostap/hostap_info.c:156:43: warning: incorrect type in
> argument 2 (different signedness)
> drivers/net/wireless/hostap/hostap_info.c:156:43:    expected unsigned long
> volatile *addr
> drivers/net/wireless/hostap/hostap_info.c:156:43:    got long *<noident>

> The warnings are fixed with the following compile-tested fix:
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

This V2 looks good.

Acked-by: Jouni Malinen <j@w1.fi>

-- 
Jouni Malinen                                            PGP id EFC895FA
