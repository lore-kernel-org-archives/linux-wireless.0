Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64895 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1HLPW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 11:22:57 -0400
Received: by yie30 with SMTP id 30so2019197yie.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 08:22:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E4543D5.9070006@lwfinger.net>
References: <1313155654-8988-4-git-send-email-zajec5@gmail.com>
	<4E4543D5.9070006@lwfinger.net>
Date: Fri, 12 Aug 2011 17:22:56 +0200
Message-ID: <CACna6ryX=N+vZ4-+CRkcZatB81U-5Acm_NfH9eNMrWZwpAvfVw@mail.gmail.com> (sfid-20110812_172301_561128_B6C5D84C)
Subject: Re: [PATCH V2 4/4] b43: HT-PHY: init: init BPHY and upload 0x1a table
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 12 sierpnia 2011 17:16 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 08/12/2011 08:27 AM, Rafał Miłecki wrote:
>>
>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>> ---
>> BPHY is something partially known from N-PHY.
>>
>> This 0x1a table with 0xc0 offset is a little tricky. We already upload
>> something like that earlier, but this is needed to stop radio going crazy
>> and transmissint crap.
>
> I don't care that the commit message contains "crap", but others might. I
> do, however, want you to change from the nonexistent "transmissint" to
> "transmission" or "transmitting", whichever you mean.
>
> Other than that, ACK. Note, I have no HT device, thus I have done no
> testing.

Err, that's comment, not commit message. Won't be visible in "git log".

Should I still change it?

-- 
Rafał
