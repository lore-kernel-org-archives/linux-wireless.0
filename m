Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34048 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbbGUOUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 10:20:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<wil6210@qca.qualcomm.com>,
	Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
Subject: Re: [PATCH 11/13] wil6210: TSO implementation
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1436081080-27305-12-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<CANUX_P0OLXxf_kj2SaYOeeQmQ7XHOhjMWia76--CLq15pXKWRQ@mail.gmail.com>
	<2576505.6RpAF3j2eF@lx-wigig-72>
Date: Tue, 21 Jul 2015 17:20:18 +0300
In-Reply-To: <2576505.6RpAF3j2eF@lx-wigig-72> (Vladimir Kondratiev's message
	of "Thu, 9 Jul 2015 14:37:22 +0300")
Message-ID: <87r3o1mw2l.fsf@kamboji.qca.qualcomm.com> (sfid-20150721_162028_454691_FDB30C63)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> On Wednesday, July 08, 2015 10:06:37 PM Emmanuel Grumbach wrote:
>> So your device is able to replicate and update the IP / TCP header?
>> I don't really follow what your device is able to do.
>> You seem to be cutting the frags so that their length sums up to mss.
>> Which hints that your device can't segment the buffer by itself. OTOH,
>> I don't see how you treat the IP / TCP header copy and modification.
>> 
> Emmanuel:
> Yes, it is correct - hardware know to replicate IP/TCP header; and
> DMA written in such a way that I have to arrange fragments to
> sums up to MSS.
>
> So this code fragment is OK. We tested it with lots of traffic.
> However, after your comments for another code fragment,
> I found there is a way to do it better. I'll rework and send updated patch.
>
> Kalle: please drop this patch. The rest of patches should apply cleanly
> without this one.

Ok, dropped this patch.

-- 
Kalle Valo
