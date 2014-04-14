Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17302 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaDNIFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 04:05:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: double check bmi xfer pointers
References: <53461A8A.4030209@candelatech.com>
	<1397124355-6321-1-git-send-email-michal.kazior@tieto.com>
	<8738hkh193.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=gUBsw43M2at0y7iZU3VhwdjH9EBqzdOmKpxLjjqusPw@mail.gmail.com>
	<CA+BoTQ=L7Cj5V04RGEFcdGm1rxEO8NOYMEhSRiQNdoBoMTm5Pg@mail.gmail.com>
Date: Mon, 14 Apr 2014 11:05:11 +0300
In-Reply-To: <CA+BoTQ=L7Cj5V04RGEFcdGm1rxEO8NOYMEhSRiQNdoBoMTm5Pg@mail.gmail.com>
	(Michal Kazior's message of "Fri, 11 Apr 2014 09:58:54 +0200")
Message-ID: <877g6sfia0.fsf@kamboji.qca.qualcomm.com> (sfid-20140414_100528_267416_CDB48527)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> I conclude the bug is not present in the vanilla ath10k code.
>
> TL;DR drop the patch, please

Hehe. Thanks, I have dropped the patch.

-- 
Kalle Valo
