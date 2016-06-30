Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42184 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbcF3L02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 07:26:28 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Chaehyun Lim <chaehyun.lim@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] ath10k: remove unused <linux/semaphore.h>
Date: Thu, 30 Jun 2016 11:26:22 +0000
Message-ID: <87inwq6hpe.fsf@kamboji.qca.qualcomm.com> (sfid-20160630_132645_629127_56CCDB6D)
References: <20160621114539.15313-1-chaehyun.lim@gmail.com>
	<bf7b2008-b333-2d79-a952-fda895da8479@cogentembedded.com>
In-Reply-To: <bf7b2008-b333-2d79-a952-fda895da8479@cogentembedded.com> (Sergei
	Shtylyov's message of "Tue, 21 Jun 2016 16:46:00 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> writes:

> On 6/21/2016 2:45 PM, Chaehyun Lim wrote:
>
>> <linux/semaphore.h> is not used anymore, so just remove it.
>
>    s/it/#include/?

Fixed that in the pending branch.

-- 
Kalle Valo