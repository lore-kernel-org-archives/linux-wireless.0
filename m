Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24778 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaCGIM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 03:12:56 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k:  support msdu chaining.
References: <1393884429-8426-1-git-send-email-greearb@candelatech.com>
Date: Fri, 7 Mar 2014 10:12:50 +0200
In-Reply-To: <1393884429-8426-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Mon, 3 Mar 2014 14:07:09
	-0800")
Message-ID: <87ha7apgu5.fsf@kamboji.qca.qualcomm.com> (sfid-20140307_091259_438509_38A07A95)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Consolidate the list of msdu skbs into the msdu-head skb, delete the
> rest of the skbs, pass the msdu-head skb on up the stack as normal.
>
> Tested with high-speed TCP and UDP traffic on modified firmware that
> supports raw-rx.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, applied.

-- 
Kalle Valo
