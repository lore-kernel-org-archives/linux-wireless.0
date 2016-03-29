Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271AbcC2PUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 11:20:04 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	joe@perches.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8723au: Remove unused functions
References: <1458972892-14169-1-git-send-email-bhumirks@gmail.com>
Date: Tue, 29 Mar 2016 11:20:03 -0400
In-Reply-To: <1458972892-14169-1-git-send-email-bhumirks@gmail.com> (Bhumika
	Goyal's message of "Sat, 26 Mar 2016 11:44:52 +0530")
Message-ID: <wrfjmvphwbto.fsf@redhat.com> (sfid-20160329_172030_317269_3119A72B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bhumika Goyal <bhumirks@gmail.com> writes:
> The functions rtw_get_oper_bw23a and rtw_get_oper_ch23aoffset are never
> used anywhere in the kernel. So, remove their definition and prototype.
> Grepped to find occurences.
>
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_wlan_util.c   | 10 ----------
>  drivers/staging/rtl8723au/include/rtw_mlme_ext.h |  2 --
>  2 files changed, 12 deletions(-)

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
