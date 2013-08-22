Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:55181 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab3HVKF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 06:05:27 -0400
Received: by mail-bk0-f43.google.com with SMTP id mz13so591328bkb.16
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2013 03:05:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 22 Aug 2013 12:05:25 +0200
Message-ID: <CA+BoTQksSJEJnkArCGb5Vkn=9REYSsfQ0HEsdrkoqNF-5FOj1w@mail.gmail.com> (sfid-20130822_120530_846236_7EE47A36)
Subject: Re: [PATCH 0/3] ath10k: fixes
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 August 2013 08:34, Michal Kazior <michal.kazior@tieto.com> wrote:
> Hi,
>
> This patchset addresses some throughput issues.
>
>
> Pozdrawiam / Best regards,
> Michal Kazior.
>
>
> Michal Kazior (3):
>   ath10k: make the workqueue multithreaded
>   ath10k: move htt rx processing to worker
>   ath10k: fix issues on non-preemptible systems
>
>  drivers/net/wireless/ath/ath10k/core.c   |    4 ++-
>  drivers/net/wireless/ath/ath10k/core.h   |    7 ++++
>  drivers/net/wireless/ath/ath10k/htc.c    |    4 +++
>  drivers/net/wireless/ath/ath10k/htt.h    |    3 ++
>  drivers/net/wireless/ath/ath10k/htt_rx.c |   58 ++++++++++++++++++++++++++----
>  drivers/net/wireless/ath/ath10k/wmi.c    |    4 +++
>  6 files changed, 72 insertions(+), 8 deletions(-)

Drop this patchset for now, please, There are some minor issues I'd
like to address first. Nevertheless, feel free to comment the patchset
if you see any issues.


Pozdrawiam / Best regards,
Michał Kazior.
