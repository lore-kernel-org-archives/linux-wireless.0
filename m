Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:48511 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaB0Gw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 01:52:56 -0500
Received: by mail-lb0-f173.google.com with SMTP id p9so1389899lbv.32
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 22:52:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87a9ddlrqm.fsf@kamboji.qca.qualcomm.com>
References: <1393311399-8070-1-git-send-email-janusz.dziedzic@tieto.com>
	<87a9ddlrqm.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 27 Feb 2014 07:52:54 +0100
Message-ID: <CALhHN=pgPNT4EktfMkQNiS_qa2uXDq9BBovzq6YPEurEEHMqDg@mail.gmail.com> (sfid-20140227_075315_828632_5EE527DF)
Subject: Re: [PATCH] ath10k: skip management frames in HTT path
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 February 2014 18:16, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> After we pass frames with INV_PEER to upper layer in patch:
>>
>> ath10k: pass frames with invalid peer status to upper layer
>>
>> we could pass some management frames (in case INVALID_PEER
>> and MGMT_CTRL) twice to upper layer, once via WMI and once
>> via HTT. Next we could handle assoc request twice. This
>> patch remove such regression.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> I saw a conflict and also did some commit log cleanup. Please check:
>
> https://github.com/kvalo/ath/commit/dd0063fba4434d22fb8a6e6d79bf23cc36f6916a
>
looks good.

BR
Janusz
