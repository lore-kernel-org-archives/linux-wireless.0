Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18665 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754076AbdLGOg3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 09:36:29 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: improve endianness handling
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171202095413.GA12091@blackstone>
References: <20171202095413.GA12091@blackstone>
To: Kenneth Lu <kuohsianglu@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>
Message-ID: <a9fb908e4549497983af2e51b1535c52@euamsexm01a.eu.qualcomm.com> (sfid-20171207_153712_246823_62F1C836)
Date: Thu, 7 Dec 2017 15:36:22 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kenneth Lu <kuohsianglu@gmail.com> wrote:

> Replace ntohs with be16_to_cpu to do endian conversions for ethhdr
> h_proto assignment.
> 
> Signed-off-by: Kenneth Lu <kuohsianglu@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

5d24bcd56dc7 ath6kl: improve endianness handling

-- 
https://patchwork.kernel.org/patch/10088565/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
