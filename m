Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:46992 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3K0KZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 05:25:46 -0500
Received: by mail-bk0-f47.google.com with SMTP id mx12so3119805bkb.34
        for <linux-wireless@vger.kernel.org>; Wed, 27 Nov 2013 02:25:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385474260-22385-2-git-send-email-michal.kazior@tieto.com>
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
	<1385474260-22385-1-git-send-email-michal.kazior@tieto.com>
	<1385474260-22385-2-git-send-email-michal.kazior@tieto.com>
Date: Wed, 27 Nov 2013 11:25:45 +0100
Message-ID: <CA+BoTQmtkBGpktbLRfmiLuLDKP9TnUeWu4OMeGUsVcq7m05u4Q@mail.gmail.com> (sfid-20131127_112551_029392_CB0E2653)
Subject: Re: [PATCH v2 1/3] ath10k: use nss provided by mac80211
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 November 2013 14:57, Michal Kazior <michal.kazior@tieto.com> wrote:
> Calculating STA NSS just from the mcs rateset is
> not the greatest idea.
>
> This should prevent connectivity issues if
> mac80211 is ever to set rx_nss to something other
> rather than base on max mcs map. As an example
> operation mode change notification in assoc
> request may change rx_nss initial values in the
> future.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

Drop this single patch, please.

I just noticed rx_nss doesn't seem to have correct value when associating..


Michał
