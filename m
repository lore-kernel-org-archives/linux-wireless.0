Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41053 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbcHOIYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 04:24:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wefe@cypress.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	"brcm80211-dev-list.pdl\@broadcom.com"
	<brcm80211-dev-list.pdl@broadcom.com>,
	"franky.lin\@broadcom.com" <franky.lin@broadcom.com>,
	"hante.meuleman\@broadcom.com" <hante.meuleman@broadcom.com>,
	"pieterpg\@broadcom.com" <pieterpg@broadcom.com>,
	"Chi-Hsien Lin" <chln@cypress.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: shut down AP and set IBSS mode only on primary interface
References: <20160810080100.GA10783@cypress.com>
	<4d60ec5e-6462-372a-2d3c-5770493e7e98@broadcom.com>
	<DM5PR06MB28258E50D25AE4221558BA28D91D0@DM5PR06MB2825.namprd06.prod.outlook.com>
	<cab5a204-3487-ebe6-7e82-ca6dbb04ff40@broadcom.com>
	<871t1qe9u3.fsf@kamboji.qca.qualcomm.com>
	<DM5PR06MB28259759C91C4ACBDB719EF9D9120@DM5PR06MB2825.namprd06.prod.outlook.com>
Date: Mon, 15 Aug 2016 11:24:48 +0300
In-Reply-To: <DM5PR06MB28259759C91C4ACBDB719EF9D9120@DM5PR06MB2825.namprd06.prod.outlook.com>
	(Wright Feng's message of "Mon, 15 Aug 2016 08:11:07 +0000")
Message-ID: <87inv2cucv.fsf@kamboji.qca.qualcomm.com> (sfid-20160815_102500_296549_0ED74D0E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wefe@cypress.com> writes:

>> -----Original Message-----
>> From: Kalle Valo [mailto:kvalo@codeaurora.org]
>> Sent: Monday, August 15, 2016 4:05 PM
>> To: Arend Van Spriel <arend.vanspriel@broadcom.com>
>> Cc: Wright Feng <wefe@cypress.com>; brcm80211-dev-
>> list.pdl@broadcom.com; franky.lin@broadcom.com;
>> hante.meuleman@broadcom.com; pieterpg@broadcom.com; Chi-Hsien Lin
>> <chln@cypress.com>; linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH] brcmfmac: shut down AP and set IBSS mode only on
>> primary interface
>>
>> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>>
>> >> This message and any attachments may contain Cypress (or its
>> >> subsidiaries) confidential information. If it has been received in
>> >> error, please advise the sender and immediately delete this message.
>> >
>> > Is there any way for you to get rid of this foot note. It may keep
>> > Kalle from taking this patch.
>>
>> Correct. I'll automatically drop patches with these kind of notices.
>
> I've removed the foot note and sent the [PATCH v2] to you on 8/11.
> Is that okay to you?

>From a quick look seems to be ok. But I'll do proper review later, need
to go through pile of mails after coming back from vacation.

-- 
Kalle Valo
