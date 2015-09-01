Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:32984 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbbIAU0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 16:26:12 -0400
Received: by ykei199 with SMTP id i199so2421595yke.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2015 13:26:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CA6A223-16CD-4A0F-A671-6B4BB026CB82@holtmann.org>
References: <1440462512.2670.83.camel@perches.com> <1440507403-9695-1-git-send-email-jprvita@endlessm.com>
 <4CA6A223-16CD-4A0F-A671-6B4BB026CB82@holtmann.org>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Tue, 1 Sep 2015 16:25:32 -0400
Message-ID: <CA+A7VXVwmDEboDq-nACJH2n-UquTkO1i-+xgEm32OD5EDVfQfg@mail.gmail.com> (sfid-20150901_222629_811914_F3B5BC93)
Subject: Re: [PATCH] rfkill: Copy "all" global state to other types
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

On 25 August 2015 at 12:13, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Joao Paulo,
>
>> When switching the state of all RFKill switches of type all we need to
>> replicate the RFKILL_TYPE_ALL global state to all the other types global
>> state, so it is used to initialize persistent RFKill switches on
>> register.
>>
>> Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
>> ---
>> net/rfkill/core.c | 9 ++++++++-
>> 1 file changed, 8 insertions(+), 1 deletion(-)
>
> Acked-by: Marcel Holtmann <marcel@holtmann.org>
>

Any feedback or any plans to pick this for mac80211-next (which I
understand is where it should go to be sent upstream)?

Thanks,

--
João Paulo Rechi Vita
http://about.me/jprvita
