Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46850 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbIBRmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 13:42:11 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Subject: Re: [PATCH] rfkill: Copy "all" global state to other types
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CA+A7VXVwmDEboDq-nACJH2n-UquTkO1i-+xgEm32OD5EDVfQfg@mail.gmail.com>
Date: Wed, 2 Sep 2015 10:42:04 -0700
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?utf-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Message-Id: <87B673AF-9598-42D6-B77E-1F2F08A579FC@holtmann.org> (sfid-20150902_194214_616396_54676BE3)
References: <1440462512.2670.83.camel@perches.com> <1440507403-9695-1-git-send-email-jprvita@endlessm.com> <4CA6A223-16CD-4A0F-A671-6B4BB026CB82@holtmann.org> <CA+A7VXVwmDEboDq-nACJH2n-UquTkO1i-+xgEm32OD5EDVfQfg@mail.gmail.com>
To: =?utf-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joao,

>>> When switching the state of all RFKill switches of type all we need to
>>> replicate the RFKILL_TYPE_ALL global state to all the other types global
>>> state, so it is used to initialize persistent RFKill switches on
>>> register.
>>> 
>>> Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
>>> ---
>>> net/rfkill/core.c | 9 ++++++++-
>>> 1 file changed, 8 insertions(+), 1 deletion(-)
>> 
>> Acked-by: Marcel Holtmann <marcel@holtmann.org>
>> 
> 
> Any feedback or any plans to pick this for mac80211-next (which I
> understand is where it should go to be sent upstream)?

I can take this through bluetooth-next tree if there are no objections.

Regards

Marcel

