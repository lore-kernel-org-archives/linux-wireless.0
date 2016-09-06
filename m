Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0027.hostedemail.com ([216.40.44.27]:46413 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933337AbcIFQIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 12:08:53 -0400
Message-ID: <1473178128.8300.8.camel@perches.com> (sfid-20160906_180914_566046_0DC74CB1)
Subject: Re: [PATCH 0/5] Some cleanup patches for
 drivers/staging/rtl8723au/core/rtw_mlme.c
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Matthias Beyer <mail@beyermatthias.de>
Cc: gregkh@linuxfoundation.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>,
        Geliang Tang <geliangtang@163.com>,
        Cihangir Akturk <cakturk@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 06 Sep 2016 09:08:48 -0700
In-Reply-To: <wrfjshtdyq56.fsf@redhat.com>
References: <20160904192626.17197-1-mail@beyermatthias.de>
         <wrfjshtdyq56.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-09-06 at 12:00 -0400, Jes Sorensen wrote:

> Nothing wrong with these patches, however I intend to post a patch to
> remove this driver soon, so it's kind of a waste of your time to spend
> too many cycles on it.

It might be useful to mark any drivers you're
planning on removing as "Obsolete" in MAINTAINERS.

checkpatch will then emit a "don't waste your time"
message if anyone scans an obsolete driver/file.
