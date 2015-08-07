Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbbHGNfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2015 09:35:34 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Postma <jgmpostma@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: rtl8723au: rtl8723a_hal_init: Improve code readability
References: <1438952674-9823-1-git-send-email-jgmpostma@gmail.com>
Date: Fri, 07 Aug 2015 09:35:32 -0400
In-Reply-To: <1438952674-9823-1-git-send-email-jgmpostma@gmail.com> (Johannes
	Postma's message of "Fri, 7 Aug 2015 14:04:34 +0100")
Message-ID: <wrfjzj23p6fv.fsf@redhat.com> (sfid-20150807_153551_480633_EBFA8F7B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Postma <jgmpostma@gmail.com> writes:
> This patch improves code readability in the function
> rtl8723a_cal_txdesc_chksum.  It improves the readability of the argument
> of the function le16_to_cpu.
>
> Signed-off-by: Johannes Postma <jgmpostma@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)


Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
