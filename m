Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49138 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbcF2I6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 04:58:17 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Roman Yeryomin <leroi.lists@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC/RFT] ath10k: disable wake_tx_queue for older devices
Date: Wed, 29 Jun 2016 08:58:11 +0000
Message-ID: <87oa6k8j8d.fsf@kamboji.qca.qualcomm.com> (sfid-20160629_105823_983089_B0B91A78)
References: <1463489221-24989-1-git-send-email-michal.kazior@tieto.com>
	<87inxrzqa5.fsf@kamboji.qca.qualcomm.com>
	<CACiydbLvke0UxJbg2sn0q-=FwXpmX+FKUV7wwEMT=qUYekJrJA@mail.gmail.com>
In-Reply-To: <CACiydbLvke0UxJbg2sn0q-=FwXpmX+FKUV7wwEMT=qUYekJrJA@mail.gmail.com>	(Roman
 Yeryomin's message of "Wed, 8 Jun 2016 14:39:03 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roman Yeryomin <leroi.lists@gmail.com> writes:

> On 2 June 2016 at 16:14, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> Some setups suffer performance regressions with
>>> current wake_tx_queue implementation.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>> ---
>>> Hi Roman,
>>>
>>> Can you give this patch a try and see if it helps
>>> with your performance problems, please?
>>
>> Did anyone seeing the performance regression manage to test this? It
>> would be good to get feedback, good or bad, before I push this to 4.7.
>>
>> Full patch here:
>>
>> https://patchwork.kernel.org/patch/9111981/
>
> Sorry, didn't try yet, bad timing for me :(
> Will try to test by the end of the week

Roman, did you have a chance to test this?

Michal, could you submit this patch as a formal patch, please? I think
we should take it even if Roman hasn't tested it.

-- 
Kalle Valo