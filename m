Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21670 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaJHKTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 06:19:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: add tracing for frame transmission
References: <1412615346-18010-1-git-send-email-rmanohar@qti.qualcomm.com>
	<87d2a3j1ja.fsf@kamboji.qca.qualcomm.com>
	<20141008031321.GB3116@qca.qualcomm.com>
Date: Wed, 8 Oct 2014 13:19:14 +0300
In-Reply-To: <20141008031321.GB3116@qca.qualcomm.com> (Rajkumar Manoharan's
	message of "Wed, 8 Oct 2014 08:43:23 +0530")
Message-ID: <8761fuhnj1.fsf@kamboji.qca.qualcomm.com> (sfid-20141008_121950_226514_8AF3D23F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

>> > +	trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
>> > +				     skb_tailroom(msdu));
>> 
>> Why add skb_tailroom() to the length? I think that deserves a comment.
>
> It is used for rx crypto length. skb_tailroom is used in most of the
> places even while dumping rx pkt by ath10k_dbg_dump.

Ok, thanks for clarifying that.

-- 
Kalle Valo
