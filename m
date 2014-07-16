Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:37999 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaGPKFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 06:05:44 -0400
Received: by mail-vc0-f176.google.com with SMTP id ik5so1151862vcb.21
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 03:05:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfj38e1pusb.fsf@redhat.com>
References: <1405254518-2744-1-git-send-email-rapphil@gmail.com>
	<wrfj38e1pusb.fsf@redhat.com>
Date: Wed, 16 Jul 2014 07:05:43 -0300
Message-ID: <CAENGNhekXs9+uCEQjJaDWqU9u-_GYmpb3XfZ-w2ogQd-qbjfnQ@mail.gmail.com> (sfid-20140716_120548_605374_22E4CF77)
Subject: Re: [PATCH] rtl8723au: Corrections in the coding style
From: Raphael Philipe <rapphil@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lesson Learned.
Thank you.
Raphael

On Wed, Jul 16, 2014 at 5:33 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Raphael Silva <rapphil@gmail.com> writes:
>> Some corrections were made to the code in order to conform to the
>> Kernel Coding Style.
>>
>> Signed-off-by: Raphael Silva <rapphil@gmail.com>
>> ---
>>  drivers/staging/rtl8723au/core/rtw_sta_mgt.c | 42 ++++++++++++++++++----------
>>  1 file changed, 27 insertions(+), 15 deletions(-)
>
> [jes@yoga jes.git]$ make drivers/staging/rtl8723au/r8723au.ko
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC [M]  drivers/staging/rtl8723au/core/rtw_sta_mgt.o
> drivers/staging/rtl8723au/core/rtw_sta_mgt.c: In function 'rtw_free_stainfo23a':
> drivers/staging/rtl8723au/core/rtw_sta_mgt.c:256:27: error: expected expression before ';' token
>   pstapriv->asoc_sta_count-;
>                            ^
> I fixed this up this time - next time, compile your patches before you
> post them.
>
> Thank you,
> Jes
