Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:44490 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653AbbA1Ucw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 15:32:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/6] ath9k: Add a macro to identify PCOEM chips
References: <1421633598-4488-1-git-send-email-sujith@msujith.org>
	<1421633598-4488-4-git-send-email-sujith@msujith.org>
	<21704.53700.641822.118302@gargle.gargle.HOWL>
Date: Wed, 28 Jan 2015 14:15:19 +0200
In-Reply-To: <21704.53700.641822.118302@gargle.gargle.HOWL> (Sujith
	Manoharan's message of "Wed, 28 Jan 2015 17:40:44 +0530")
Message-ID: <87oapj85k8.fsf@kamboji.qca.qualcomm.com> (sfid-20150128_225040_242008_E651F2A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Sujith Manoharan wrote:
>>  #define AR_SREV_9462(_ah) 0
>>  #define AR_SREV_9485(_ah) 0
>>  #define AR_SREV_9565(_ah) 0
>> +#define AR_SREV_9003_PCOEM(_ah) )
>
> Kalle, this is a typo - I'll resend the series.

Ok. I had actually put these into "Not Applicable" by accident and
that's why I had missed them.

-- 
Kalle Valo
