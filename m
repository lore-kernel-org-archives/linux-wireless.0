Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbcCDTPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 14:15:24 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Cihangir Akturk <cakturk@gmail.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] drivers: staging: rtl8723au: remove unneeded null test
References: <1457098990-8329-1-git-send-email-cakturk@gmail.com>
Date: Fri, 04 Mar 2016 14:15:22 -0500
In-Reply-To: <1457098990-8329-1-git-send-email-cakturk@gmail.com> (Cihangir
	Akturk's message of "Fri, 4 Mar 2016 15:43:10 +0200")
Message-ID: <wrfjpova12d1.fsf@redhat.com> (sfid-20160304_201527_893376_CD7085A0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cihangir Akturk <cakturk@gmail.com> writes:
> null test on pnetwork removed, because the iterator variable
> list_for_each_entry_safe cannot be null.
>
> This commit fixes the following error reported by coccinelle:
>
> drivers/staging/rtl8723au/core/rtw_mlme.c:1621:7-15: ERROR: iterator
> variable bound on line 1620 cannot be NULL
>
> Signed-off-by: Cihangir Akturk <cakturk@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_mlme.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)

Looks fine to me

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
