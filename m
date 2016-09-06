Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756028AbcIFQAk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 12:00:40 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: gregkh@linuxfoundation.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>,
        Geliang Tang <geliangtang@163.com>,
        Cihangir Akturk <cakturk@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Some cleanup patches for drivers/staging/rtl8723au/core/rtw_mlme.c
References: <20160904192626.17197-1-mail@beyermatthias.de>
Date: Tue, 06 Sep 2016 12:00:37 -0400
In-Reply-To: <20160904192626.17197-1-mail@beyermatthias.de> (Matthias Beyer's
        message of "Sun, 4 Sep 2016 21:26:21 +0200")
Message-ID: <wrfjshtdyq56.fsf@redhat.com> (sfid-20160906_180104_969914_026B7C0F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias Beyer <mail@beyermatthias.de> writes:
> This patchset fixes some errors and warnings reported by checkpatch.pl.
>
> Matthias Beyer (5):
>   drivers: staging: rtl8723au: core: Fix checkpatch.pl errors
>   drivers: staging: rtl8723au: core: simplify if-break-else
>   drivers: staging: rtl8723au: core: Refactor pointless branching
>   drivers: staging: rtl8723au: core: Fix "space prohibited" warning
>   drivers: staging: rtl8723au: core: Fix indentation
>
>  drivers/staging/rtl8723au/core/rtw_mlme.c | 72 ++++++++++++++-----------------
>  1 file changed, 33 insertions(+), 39 deletions(-)

Nothing wrong with these patches, however I intend to post a patch to
remove this driver soon, so it's kind of a waste of your time to spend
too many cycles on it.

Best regards,
Jes
