Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65104 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbbFIKwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 06:52:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: free wmi mgmt event skb when parsing fails
References: <1433150613-5662-1-git-send-email-rmani@qti.qualcomm.com>
Date: Tue, 9 Jun 2015 13:52:47 +0300
In-Reply-To: <1433150613-5662-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Mon, 1 Jun 2015 14:53:33 +0530")
Message-ID: <87oakpf91c.fsf@kamboji.qca.qualcomm.com> (sfid-20150609_125259_670011_A6E1BF33)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> When wmi mgmt event function fails to parse given skb,
> it should be freed on failure condition to avoid memory
> leaks. Found this during the code review.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
