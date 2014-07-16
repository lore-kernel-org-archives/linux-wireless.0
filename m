Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760577AbaGPIdr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 04:33:47 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Raphael Silva <rapphil@gmail.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] rtl8723au: Corrections in the coding style
References: <1405254518-2744-1-git-send-email-rapphil@gmail.com>
Date: Wed, 16 Jul 2014 10:33:40 +0200
In-Reply-To: <1405254518-2744-1-git-send-email-rapphil@gmail.com> (Raphael
	Silva's message of "Sun, 13 Jul 2014 09:28:38 -0300")
Message-ID: <wrfj38e1pusb.fsf@redhat.com> (sfid-20140716_103355_190062_A9786F27)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raphael Silva <rapphil@gmail.com> writes:
> Some corrections were made to the code in order to conform to the
> Kernel Coding Style.
>
> Signed-off-by: Raphael Silva <rapphil@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_sta_mgt.c | 42 ++++++++++++++++++----------
>  1 file changed, 27 insertions(+), 15 deletions(-)

[jes@yoga jes.git]$ make drivers/staging/rtl8723au/r8723au.ko
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC [M]  drivers/staging/rtl8723au/core/rtw_sta_mgt.o
drivers/staging/rtl8723au/core/rtw_sta_mgt.c: In function 'rtw_free_stainfo23a':
drivers/staging/rtl8723au/core/rtw_sta_mgt.c:256:27: error: expected expression before ';' token
  pstapriv->asoc_sta_count-;
                           ^
I fixed this up this time - next time, compile your patches before you
post them.

Thank you,
Jes
