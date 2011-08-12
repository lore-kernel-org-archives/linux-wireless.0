Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:47139 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1HLPgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 11:36:40 -0400
Received: by iye16 with SMTP id 16so1750823iye.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 08:36:40 -0700 (PDT)
Message-ID: <4E454885.1060107@lwfinger.net> (sfid-20110812_173645_063641_EA20863F)
Date: Fri, 12 Aug 2011 10:36:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH V2 4/4] b43: HT-PHY: init: init BPHY and upload 0x1a table
References: <1313155654-8988-4-git-send-email-zajec5@gmail.com>	<4E4543D5.9070006@lwfinger.net> <CACna6ryX=N+vZ4-+CRkcZatB81U-5Acm_NfH9eNMrWZwpAvfVw@mail.gmail.com>
In-Reply-To: <CACna6ryX=N+vZ4-+CRkcZatB81U-5Acm_NfH9eNMrWZwpAvfVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 10:22 AM, Rafał Miłecki wrote:
> W dniu 12 sierpnia 2011 17:16 użytkownik Larry Finger
> <Larry.Finger@lwfinger.net>  napisał:
>> On 08/12/2011 08:27 AM, Rafał Miłecki wrote:
>>>
>>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>>> ---
>>> BPHY is something partially known from N-PHY.
>>>
>>> This 0x1a table with 0xc0 offset is a little tricky. We already upload
>>> something like that earlier, but this is needed to stop radio going crazy
>>> and transmissint crap.
>>
>> I don't care that the commit message contains "crap", but others might. I
>> do, however, want you to change from the nonexistent "transmissint" to
>> "transmission" or "transmitting", whichever you mean.
>>
>> Other than that, ACK. Note, I have no HT device, thus I have done no
>> testing.
>
> Err, that's comment, not commit message. Won't be visible in "git log".
>
> Should I still change it?

Sorry I missed the ---. In the comment, it is OK.

Larry
