Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5324 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdESHz1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 03:55:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wil6210: use memdup_user
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <b5b672573585b51a3acb37231f38db45f5873f60.1493781695.git.geliangtang@gmail.com>
References: <b5b672573585b51a3acb37231f38db45f5873f60.1493781695.git.geliangtang@gmail.com>
To: Geliang Tang <geliangtang@gmail.com>
CC: Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Geliang Tang <geliangtang@gmail.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <40e20134d5f74a06947c24f58893ce0f@euamsexm01a.eu.qualcomm.com> (sfid-20170519_095603_393940_A2E36377)
Date: Fri, 19 May 2017 09:55:11 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geliang Tang <geliangtang@gmail.com> wrote:
> Use memdup_user() helper instead of open-coding to simplify the code.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Patch applied to ath-next branch of ath.git, thanks.

9a49290919e1 wil6210: use memdup_user

-- 
https://patchwork.kernel.org/patch/9715009/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
