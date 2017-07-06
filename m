Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:15429 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752045AbdGFJRh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 05:17:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v2 0/3] ath10k usb support
Date: Thu, 6 Jul 2017 09:17:29 +0000
Message-ID: <87r2xtexgn.fsf@kamboji.qca.qualcomm.com> (sfid-20170706_111744_919489_02D23815)
References: <1495312410-9937-1-git-send-email-erik.stromdahl@gmail.com>
In-Reply-To: <1495312410-9937-1-git-send-email-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sat, 20 May 2017 22:33:27 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> This is the 2nd version of the ath10k USB RFC. There are only minor updat=
es
> since last version.
>
> The main difference when compared to the previous RFC is that the
> high latency stuff that is common between USB and SDIO has been moved out
> of this patchset and into another (separate) patchset.
>
> I was actually thinking about squashing all the patches into one, but
> decided not to do so since I wanted usb.h, usb.c and the update Kconfig +
> Makefile in one separate patch.
>
> Perhaps patch 1 and 2 should be squashed?
>
> Erik Stromdahl (3):
>   ath10k: various usb related definitions
>   ath10k: different fw file names for usb
>   ath10k: add initial USB support

This looks good. I'll again do some cosmetic changes and submit v2 as
proper patch. Sorry for taking so long with this.

--=20
Kalle Valo=
