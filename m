Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:35038 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbbALMcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 07:32:04 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] ath10k: implement beacon offload
References: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 12 Jan 2015 14:31:54 +0200
In-Reply-To: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 8 Jan 2015 12:12:25 +0100")
Message-ID: <87d26kdvt1.fsf@kamboji.qca.qualcomm.com> (sfid-20150112_133209_612879_6321B247)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> New wmi-tlv firmware will support beacon/presp
> offloading. This patchset adds appropriate
> support.
>
> These patches of mine were originally posted by
> Bartosz before christmas after I went on my
> holidays.
>
> v2:
>  * add a comment in patch 5
>
>
> Michal Kazior (5):
>   ath10k: implement new beacon tx status event
>   ath10k: implement beacon template command
>   ath10k: implement prb tmpl wmi command
>   ath10k: implement p2p bcn ie command
>   ath10k: implement support for ap beacon offloading

While applying this I had few trivial commits with wmi ops. Can you
double check my resolution from ath-next-test, please? (It might take an
hour before I push the patches.)

Pushing patch "ath10k-implement-new-beacon-tx" ... done
Pushing patch "ath10k-implement-beacon-templa" ... 
  CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.c
  CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.c
  CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-ops.h
Error: The merge failed during "push".
       Revert the operation with "stg undo".
stg rebase: 3 conflict(s)


-- 
Kalle Valo
