Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932874AbcIFQLz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 12:11:55 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Matthias Beyer <mail@beyermatthias.de>, gregkh@linuxfoundation.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>,
        Geliang Tang <geliangtang@163.com>,
        Cihangir Akturk <cakturk@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Some cleanup patches for drivers/staging/rtl8723au/core/rtw_mlme.c
References: <20160904192626.17197-1-mail@beyermatthias.de>
        <wrfjshtdyq56.fsf@redhat.com> <1473178128.8300.8.camel@perches.com>
Date: Tue, 06 Sep 2016 12:11:52 -0400
In-Reply-To: <1473178128.8300.8.camel@perches.com> (Joe Perches's message of
        "Tue, 06 Sep 2016 09:08:48 -0700")
Message-ID: <wrfjk2epypmf.fsf@redhat.com> (sfid-20160906_181222_102279_9094195D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Tue, 2016-09-06 at 12:00 -0400, Jes Sorensen wrote:
>
>> Nothing wrong with these patches, however I intend to post a patch to
>> remove this driver soon, so it's kind of a waste of your time to spend
>> too many cycles on it.
>
> It might be useful to mark any drivers you're
> planning on removing as "Obsolete" in MAINTAINERS.
>
> checkpatch will then emit a "don't waste your time"
> message if anyone scans an obsolete driver/file.

I see, wasn't aware of that. I did add a printk to it for 4.6 notifying
users that the driver was going to go away.

Jes
