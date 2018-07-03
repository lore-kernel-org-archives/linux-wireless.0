Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56654 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752387AbeGCLBn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 07:01:43 -0400
Subject: Re: [PATCH 13/14] rtlwifi: access skb->data to get C2H data by macro
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
References: <20180518093007.23594-1-pkshih@realtek.com>
 <20180518093007.23594-14-pkshih@realtek.com>
 <87po1fhwfd.fsf@purkki.adurom.net> <1527732798.8418.7.camel@realtek.com>
 <87sh56f3sv.fsf@codeaurora.org> <1530597815.6330.4.camel@realtek.com>
 <87y3esrgkr.fsf@kamboji.qca.qualcomm.com>
 <b69340e7-b7ae-2b54-9488-c9c7bcffecf2@nbd.name>
 <87po04r3hk.fsf@kamboji.qca.qualcomm.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <f81556b1-22f8-cefe-0db4-8100096dbda9@nbd.name> (sfid-20180703_130147_342659_66541B0D)
Date: Tue, 3 Jul 2018 13:01:40 +0200
MIME-Version: 1.0
In-Reply-To: <87po04r3hk.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-03 12:57, Kalle Valo wrote:
>>> To me that does not make any sense, I have never heard about bit
>>> endianness any of the devices I have worked on.
>>
>> Unfortunately, the order in which these fields are laid out is different
>> between big and little endian, even when only dealing with u8.
> 
> Oh, didn't know that. Can you give some examples about endian problems
> with u8 bitfields? Still not getting it. Not that it matters, just
> curious.
On a quick google search, I found this:
http://mjfrazer.org/mjfrazer/bitfields/

- Felix
