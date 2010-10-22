Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34777 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab0JVUnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 16:43:11 -0400
Received: by iwn34 with SMTP id 34so1341250iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 13:43:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CC1EF20.5030506@lwfinger.net>
References: <1287762229-16516-2-git-send-email-zajec5@gmail.com>
 <1287762229-16516-4-git-send-email-zajec5@gmail.com> <AANLkTiko3JeoRcxPT7zhnGTNhmyDWqmFjeZ8ssMzCb+J@mail.gmail.com>
 <4CC1EF20.5030506@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 22 Oct 2010 22:42:50 +0200
Message-ID: <AANLkTikJkoGudGojjRKu1Z9GJeUrAqWLRZj6DnPpR4+y@mail.gmail.com>
Subject: Re: [PATCH 3/5] b43: define known SPROM boardflags2 bits
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/10/22 Larry Finger <Larry.Finger@lwfinger.net>:
> On 10/22/2010 02:41 PM, Gábor Stefanik wrote:
>> 2010/10/22 Rafał Miłecki <zajec5@gmail.com>:
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> ---
>>>  drivers/net/wireless/b43/b43.h |   13 +++++++++++++
>>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
>>> index 72821c4..9aad2ca 100644
>>> --- a/drivers/net/wireless/b43/b43.h
>>> +++ b/drivers/net/wireless/b43/b43.h
>>> @@ -153,6 +153,19 @@
>>>  #define B43_BFH_FEM_BT                 0x0040  /* has FEM and switch to share antenna
>>>                                                 * with bluetooth */
>>>
>>> +/* SPROM boardflags2_lo values */
>>> +#define B43_BFL2_RXBB_INT_REG_DIS      0x0001  /* external RX BB regulator present */
>>> +#define B43_BFL2_APLL_WAR              0x0002  /* alternative A-band PLL settings implemented */
>>> +#define B43_BFL2_TXPWRCTRL_EN          0x0004  /* permits enabling TX Power Control */
>>> +#define B43_BFL2_2X4_DIV               0x0008  /* 2x4 diversity switch */
>>> +#define B43_BFL2_5G_PWRGAIN            0x0010  /* supports 5G band power gain */
>>> +#define B43_BFL2_PCIEWAR_OVR           0x0020  /* overrides ASPM and Clkreq settings */
>>> +#define B43_BFL2_CAESERS_BRD           0x0040  /* is Caesers board (unused) */
>>
>> I'm almost sure this is a typo in the specs.
>>
>> Larry?
>
> Nope - it is Cae..., not Cea.... Whatever name we use is just a placeholder as
> that bit is never used.

No, I mean the "ser" part.

>
> Larry
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
