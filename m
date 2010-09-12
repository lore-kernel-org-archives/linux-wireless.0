Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61684 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab0ILVeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 17:34:37 -0400
Received: by iwn5 with SMTP id 5so4446981iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Sep 2010 14:34:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikF_089e9kTrV1wFc5a4TnhoZ9ekp2C0r-DMSE1@mail.gmail.com>
References: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
 <1284221913-22455-10-git-send-email-hauke@hauke-m.de> <AANLkTim8UUHmm_TNzg0Spm7SXm8OXfDAvhjUK7v9V-F=@mail.gmail.com>
 <1284312581.8821.34.camel@maggie> <AANLkTikF_089e9kTrV1wFc5a4TnhoZ9ekp2C0r-DMSE1@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 12 Sep 2010 14:34:16 -0700
Message-ID: <AANLkTin5mGf51p39Cje_ZpRvjH6LKo2xG4QLiw4W-ybo@mail.gmail.com>
Subject: Re: [PATCH 8/8] compat-wireless: add brcm80211 driver
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 12, 2010 at 10:36 AM, Gábor Stefanik
<netrolller.3d@gmail.com> wrote:
> On Sun, Sep 12, 2010 at 7:29 PM, Michael Büsch <mb@bu3sch.de> wrote:
>> On Sun, 2010-09-12 at 19:16 +0200, Gábor Stefanik wrote:
>>> Umm... do we accept staging drivers in compat-wireless?
>>
>> Why shouldn't we accept them in compat?
>>
>> --
>> Greetings Michael.
>>
>>
>
> Dunno, just given the general hostility of the wireless team towards
> staging drivers.

The idea is to enable users, so I'll gladly accept them, thanks
haukes, I'll apply after first reviewing your other series.

 Luis
