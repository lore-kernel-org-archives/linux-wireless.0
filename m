Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31855 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab3LPNzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 08:55:19 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Bartosz Markowski <bartosz.markowski@tieto.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] ath10k: split the if_limits and if_comb
References: <1386688840-12181-1-git-send-email-bartosz.markowski@tieto.com>
	<52A734D9.3000506@candelatech.com>
Date: Mon, 16 Dec 2013 15:55:14 +0200
In-Reply-To: <52A734D9.3000506@candelatech.com> (Ben Greear's message of "Tue,
	10 Dec 2013 07:35:53 -0800")
Message-ID: <87ob4ggat9.fsf@kamboji.qca.qualcomm.com> (sfid-20131216_145530_776228_894DA9E8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 12/10/2013 07:20 AM, Bartosz Markowski wrote:
>> Split the interface limits and inteface combination,
>> to reflect the 10.X capabilites (no P2P, no STA and 8 VAP).
>
> My 10.X firmware works just fine with stations..I just tested up
> to 32 of them.
>
> Maybe add firmware IEs to explicitly advertise how many it can
> support instead of setting one flag and making assumptions?

That can be done in a separate patch.

-- 
Kalle Valo
