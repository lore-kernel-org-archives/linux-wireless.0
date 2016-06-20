Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36944 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbcFTV5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 17:57:10 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 01/21] ath10k: Fix crash related to printing features.
Date: Mon, 20 Jun 2016 21:56:38 +0000
Message-ID: <874m8no76y.fsf@kamboji.qca.qualcomm.com> (sfid-20160620_235713_469429_39EC5419)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
	<1462986153-16318-2-git-send-email-greearb@candelatech.com>
	<576856E6.2030003@candelatech.com>
In-Reply-To: <576856E6.2030003@candelatech.com> (Ben Greear's message of "Mon,
	20 Jun 2016 13:49:42 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 05/11/2016 10:02 AM, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This looks like a regression from
>> c4cdf753 (move fw_features to struct ath10k_fw_file)
>
> Just FYI, this patch does not appear to be in 4.7-rc4 as of today, and
> so kernel crashes on startup when loading ath10k, at least when
> DBG_BOOT logging is enabled....

The fix is wireless-drivers.git now, I'm planning to send a pull request
to Dave tomorrow.

-- 
Kalle Valo