Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40262 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752302AbeENOvJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 10:51:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Peter Oh <peter.oh@bowerswilkins.com>
Cc: Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath: Add support to get the detected radar specifications
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
        <1525110339-25326-2-git-send-email-srirrama@codeaurora.org>
        <cf60f81c-9466-ac52-e902-413fe3163490@bowerswilkins.com>
Date: Mon, 14 May 2018 17:51:04 +0300
In-Reply-To: <cf60f81c-9466-ac52-e902-413fe3163490@bowerswilkins.com> (Peter
        Oh's message of "Mon, 30 Apr 2018 12:01:45 -0700")
Message-ID: <871sees33b.fsf@kamboji.qca.qualcomm.com> (sfid-20180514_165112_814508_0FBBBAB8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <peter.oh@bowerswilkins.com> writes:

> On 04/30/2018 10:45 AM, Sriram R wrote:
>> This enables ath10k/ath9k drivers to collect the specifications of the
>> radar type once it is detected by the dfs pattern detector unit.
>> Usage of the collected info is specific to driver implementation.
>> For example, collected radar info could be used by the host driver
>> to send to co-processors for additional processing/validation.
>
> What kind of additional processing/validation does it do?
> Please give us more details for that.

This is handled in patch 2.

-- 
Kalle Valo
