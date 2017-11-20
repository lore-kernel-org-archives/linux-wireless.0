Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53679 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdKTQPg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 11:15:36 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix data rx for CCMP-256, GCMP and GCMP-256 in raw mode
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1509079154-22759-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1509079154-22759-1-git-send-email-vthiagar@qti.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Message-ID: <2d6293d2e0f04e98ad0ef1f08f3b7a34@eusanexr01a.eu.qualcomm.com> (sfid-20171120_171540_015803_D8EE7A20)
Date: Mon, 20 Nov 2017 08:15:31 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> wrote:

> Make sure 16-byte mic is removed from the rx data packet
> tail when CCMP-256, GCMP and GCMP-256 ciphers are used
> in raw decap mode. This fixed rx traffic failures in those
> ciphers in raw mode. Split the helper returning crypto
> tail length into two, one to get the ICV length and other
> to get the mic lengh for the cipher to make it clean.
> 
> Fixes: 2ea9f12cefe4 ("ath10k: add new cipher suite support")
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-current branch of ath.git, thanks.

307aeb31af0d ath10k: fix data rx for CCMP-256, GCMP and GCMP-256 in raw mode

-- 
https://patchwork.kernel.org/patch/10029097/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
