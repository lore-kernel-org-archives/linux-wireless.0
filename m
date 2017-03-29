Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932204AbdC2Ryz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 13:54:55 -0400
Subject: Re: [PATCH] staging: Add rtl8723bs sdio wifi driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20170329174751.13184-1-hdegoede@redhat.com>
Cc: Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        linux-wireless@vger.kernel.org
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <4367ffb0-d681-8648-d209-c709c9ad5ecb@redhat.com> (sfid-20170329_195520_482804_5FF57502)
Date: Wed, 29 Mar 2017 19:54:52 +0200
MIME-Version: 1.0
In-Reply-To: <20170329174751.13184-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I forgot to add --compose so I could add the cover letter I had
already written, so here it goes:

Hi Greg, all,

I'm hereby submitting the rtl8723bs driver which
Bastien Nocera and Larry Finger have been maintaining at:

https://github.com/hadess/rtl8723bs

For inclusion into staging, like most of the other rtl*
drivers in staging this is a cleaned up version of Realtek's
own driver code for Linux.

I would like to see this added to staging because the
rtl8723bs is found on quite a few systems used by Linux users,
such as on Atom systems (Intel Computestick and various other
Atom based devices) and on many (budget) ARM boards such as
the CHIP.

The plan moving forward with this is for the new clean,
written from scratch, rtl8xxxu driver to eventually gain
support for sdio devices. But there is no clear timeline
for that as Jes is doing that in his spare time, so
I would like to see this driver included in staging for now.

Regards,

Hans
