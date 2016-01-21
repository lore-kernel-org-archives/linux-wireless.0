Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38708 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbcAUNYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:24:46 -0500
Received: by mail-wm0-f53.google.com with SMTP id b14so80612747wmb.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 05:24:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453382007-24622-1-git-send-email-michal.kazior@tieto.com>
References: <1452693668-30030-1-git-send-email-michal.kazior@tieto.com>
	<1453382007-24622-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 21 Jan 2016 14:24:44 +0100
Message-ID: <CA+BoTQkp7fyRVXSW4Ox-wD52YGqLJVNV7Qa4eSzS4UQzUoEJsQ@mail.gmail.com> (sfid-20160121_142450_709720_4567E503)
Subject: Re: [PATCH 0/5] ath10k: add basic hostq support
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 January 2016 at 14:13, Michal Kazior <michal.kazior@tieto.com> wrote:
> There's a new firmware feature which uses a shared
> DMA memory so host can share it's per-sta per-tid
> queue size which is then subsequently used for
> firmware to assist in deciding which frames to put
> on the intermediate host-device tx queue.
>
> This patchset adds only basic support to make
> the firmware supporting the feature happy and
> running at all. Without it firmware would freeze
> shortly after booting.
>
> More patches will follow some time later to add
> the "new data path" logic.
>
>
> v2:
>  * fix gfp allocation [Ben]

Sorry for wrong email subjects. Apparently git send-email wasn't happy
with "--subject PATCHv2" as opposed to "--subject=PATCHv2" ..


Michał
