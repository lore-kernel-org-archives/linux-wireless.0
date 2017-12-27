Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:24673 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbdL0KTY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Dec 2017 05:19:24 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: advertising tdls wider bandwidth support for 5GHz
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1513866642-709-1-git-send-email-bpothuno@qti.qualcomm.com>
References: <1513866642-709-1-git-send-email-bpothuno@qti.qualcomm.com>
To: <bpothuno@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Balaji Pothunoori" <bpothuno@qti.qualcomm.com>
Message-ID: <497244afaa474095914d5d6821dcdf83@euamsexm01a.eu.qualcomm.com> (sfid-20171227_111929_092109_BA0486B5)
Date: Wed, 27 Dec 2017 11:19:17 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bpothuno@qti.qualcomm.com wrote:

> Enable TDLS wider bandwidth support for 5GHz based on firmware wmi capabilities.
> 
> This patch is required for chipset QCA9888. Tested with firmware version
> 10.4-3.5.1-00018.
> 
> Signed-off-by: Balaji Pothunoori <bpothuno@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

14d65775687c ath10k: advertise TDLS wider bandwidth support for 5GHz

-- 
https://patchwork.kernel.org/patch/10127717/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
