Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:11505 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaCXIdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 04:33:12 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix the peer mac address in getting stats
References: <1395380076-4306-1-git-send-email-yeohchunyeow@gmail.com>
Date: Mon, 24 Mar 2014 10:33:05 +0200
In-Reply-To: <1395380076-4306-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Fri, 21 Mar 2014 13:34:36 +0800")
Message-ID: <87zjkg6loe.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_093349_384891_6ADA64EE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> Using the macro to convert the MAC address from WMI word
> format to char array has lead to the wrong peer mac
> address printed out while retrieving the peer stats from
> FW. Fix this.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Thanks, applied.

-- 
Kalle Valo
