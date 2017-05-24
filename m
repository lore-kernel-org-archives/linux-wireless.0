Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763160AbdEXIq4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 04:46:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: fix REG_USTIME_TSF register definition
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170519150240.GA47825@ns.kevlo.org>
References: <20170519150240.GA47825@ns.kevlo.org>
To: Kevin Lo <kevlo@kevlo.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20170524084655.F2EDA607DE@smtp.codeaurora.org> (sfid-20170524_104708_127602_3F4A4ADC)
Date: Wed, 24 May 2017 08:46:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kevin Lo <kevlo@kevlo.org> wrote:
> The REG_USTIME_TSF (US Time Tuning for TSF) definition of Realtek chips
> should be 0x55C.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

Larry, is this ok to take?

-- 
https://patchwork.kernel.org/patch/9737421/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
