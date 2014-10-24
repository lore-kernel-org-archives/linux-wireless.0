Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:51320 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbaJXN5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 09:57:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yanbo Li <yanbol@qti.qualcomm.com>
CC: <senthilb@qti.qualcomm.com>, <dreamfly281@gmail.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v3] Add the target register read/write and memory dump debugfs interface
References: <1413823085-3187-1-git-send-email-yanbol@qti.qualcomm.com>
Date: Fri, 24 Oct 2014 16:57:01 +0300
In-Reply-To: <1413823085-3187-1-git-send-email-yanbol@qti.qualcomm.com> (Yanbo
	Li's message of "Tue, 21 Oct 2014 00:38:05 +0800")
Message-ID: <87lho5muz6.fsf@kamboji.qca.qualcomm.com> (sfid-20141024_155718_749623_014D4BE1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yanbo Li <yanbol@qti.qualcomm.com> writes:

> The debugfs interface reg_addr&reg_val used to read and write the target
> register.
> The interface mem_addr&mem_val used to dump the targer memory and also
> can be used to assign value to target memory

I think you got the mail from kbuild bot already, but this patch has a
sparse warning:

>> drivers/net/wireless/ath/ath10k/debug.c:1182:26: sparse: incorrect type in assignment (different base types)
   drivers/net/wireless/ath/ath10k/debug.c:1182:26:    expected restricted __le32 [usertype] <noident>
   drivers/net/wireless/ath/ath10k/debug.c:1182:26:    got unsigned int [unsigned] [addressable] [usertype] mem_val

-- 
Kalle Valo
