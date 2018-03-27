Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58956 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbeC0LsG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 07:48:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Izzy Kulbe <kernel@unikorn.me>
Cc: luciano.coelho@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: add device ID for Rivet Networks Killer Wireless-AC 1550
References: <1522148065.12122.5.camel@unikorn.me>
Date: Tue, 27 Mar 2018 14:48:01 +0300
In-Reply-To: <1522148065.12122.5.camel@unikorn.me> (Izzy Kulbe's message of
        "Tue, 27 Mar 2018 12:54:25 +0200")
Message-ID: <87370lrb7y.fsf@kamboji.qca.qualcomm.com> (sfid-20180327_134809_676337_55B9156E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Izzy Kulbe <kernel@unikorn.me> writes:

> nvm the last message, attached the wrong file using the 9270 instead of the 9260 firmware, which obviously wouldn't work. Here's the working patch:
>
>
> Add support for Rivet Networks Killer Wireless-AC 1550 chipset, 
> which is using the Intel Wireless-AC 9260 chip
>
> Signed-off-by: Izzy Kulbe <kernel@unikorn.me>
>
> ---

You should put the comment "nvm the last message..." under the "---"
line so that git-am can ignore it.

-- 
Kalle Valo
