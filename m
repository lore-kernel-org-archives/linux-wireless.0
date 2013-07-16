Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41299 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3GPH1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:27:49 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk13so108757bkc.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 00:27:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373959193-5164-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
	<1373959193-5164-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 16 Jul 2013 09:27:46 +0200
Message-ID: <CA+BoTQ=z13xwBU5o414uEqpjwaTarW7bUwu1M5Ms9QNB8dk2EQ@mail.gmail.com> (sfid-20130716_092752_573811_E3B979FA)
Subject: Re: [PATCH v3 00/10] ath10k: device setup refactor
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 July 2013 09:19, Michal Kazior <michal.kazior@tieto.com> wrote:
> This is a respin of my patchset that addresses
> hibernation issues.
>
> This is also groundwork for proper hw recovery
> that I'm going to post too.
>
> v3:
>  * update comments in pci logic decoupling
>  * add missing commit message for one of the patches
>  * update commit message for free_vdev_map patch
>
> Michal Kazior (10):
>   ath10k: decouple pci start/stop logic
>   ath10k: decouple core start/stop logic
>   ath10k: allow deferred regd update
>   ath10k: reset BMI state upon init
>   ath10k: decouple suspend code
>   ath10k: move free_vdev_map initialization
>   ath10k: make sure all resources are freed upon ath10k_stop()
>   ath10k: defer hw setup to start/stop mac80211 hooks
>   ath10k: store firmware files in memory
>   ath10k: skip fw stats debugfs interface if device is down
>
>  drivers/net/wireless/ath/ath10k/bmi.c   |    6 +
>  drivers/net/wireless/ath/ath10k/bmi.h   |    1 +
>  drivers/net/wireless/ath/ath10k/core.c  |  249 +++++++++++++++++----------
>  drivers/net/wireless/ath/ath10k/core.h  |   16 +-
>  drivers/net/wireless/ath/ath10k/debug.c |   30 ++--
>  drivers/net/wireless/ath/ath10k/hif.h   |   39 +++++
>  drivers/net/wireless/ath/ath10k/mac.c   |  151 ++++++++++++++++-
>  drivers/net/wireless/ath/ath10k/pci.c   |  283 +++++++++++++------------------
>  8 files changed, 497 insertions(+), 278 deletions(-)

Oh shoot. I got the patchset version wrong and had a typo in the new
ath10k mailing list address. Disregard this, please. I'll resend.

Sorry for the noise.


Pozdrawiam / Best regards,
Micha³ Kazior.
