Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34066 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbCKMiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 08:38:50 -0400
Received: by iecsl2 with SMTP id sl2so26919462iec.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2015 05:38:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425905138-9966-1-git-send-email-marek.puzyniak@tieto.com>
References: <1425905138-9966-1-git-send-email-marek.puzyniak@tieto.com>
Date: Wed, 11 Mar 2015 13:38:49 +0100
Message-ID: <CADnKcVi-we6TSPMNgboS5B9ead7Xiv+tukNZhEiboN+Eb_x6Vg@mail.gmail.com> (sfid-20150311_133857_170582_F7FBDF23)
Subject: Re: [PATCH v3 0/3] ath10k: add basic tdls support
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 March 2015 at 13:45, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
> This patchset introduces tdls funtionality without tdls peer uapsd
> and tdls channel switching. Tdls is supported by qca6174 hardware
> what is indicated by firmware through supported services.
[...]
> Marek Puzyniak (2):
>   ath10k: make peer type configurable
>   ath10k: introduce basic tdls functionality
>
> Michal Kazior (1):
>   ath10k: unify tx mode and dispatch
[...]

Kalle, please drop this patchset. I will send new version.

Thanks,
Marek
