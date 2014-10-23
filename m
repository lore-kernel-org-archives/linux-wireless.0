Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50927 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaJWQhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 12:37:16 -0400
Received: by mail-wi0-f178.google.com with SMTP id q5so1300311wiv.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2014 09:37:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADxDmp5Jaze5TXRDp8HR+W1Q5fy=ba9rv8LbvtM_RinapXQGCg@mail.gmail.com>
References: <5447CF6D.3010401@mailservices.uwaterloo.ca>
	<CAJ-Vmo=y=dwZjBHqbsqP5cPK+jL91W-OyA7=y8tqowgSLJKAwA@mail.gmail.com>
	<54490E8A.50607@mailservices.uwaterloo.ca>
	<CADxDmp7gHzvJGXjC14DKf8ngbVTAdWL3twFvbdsYoGCMgvJ8Rg@mail.gmail.com>
	<CADxDmp5Jaze5TXRDp8HR+W1Q5fy=ba9rv8LbvtM_RinapXQGCg@mail.gmail.com>
Date: Thu, 23 Oct 2014 09:37:15 -0700
Message-ID: <CAJ-Vmom9UnC_9AyihVDJPUJvuAg9CVH1jXgnOL+F1f5kOihaig@mail.gmail.com> (sfid-20141023_183721_995909_6D841989)
Subject: Re: [ath9k-devel] Block ACK without frame aggregation
From: Adrian Chadd <adrian@freebsd.org>
To: Kamran Nishat <kamran.nishat@gmail.com>
Cc: Ali Abedi <a2abedi@uwaterloo.ca>,
	"(ath9k-devel@lists.ath9k.org)" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't think the hardware supports immediate-BA. :(



-a

On 23 October 2014 07:32, Kamran Nishat <kamran.nishat@gmail.com> wrote:
> It is a part of 802.11n because of compatibility with 802.11e. But because
> 802.11n gives a much more advanced AMPDU based thing I think no one
> implemented it.  It not a mandatory  part of WMM I suppose.
>
> On Thu, Oct 23, 2014 at 7:22 PM, Kamran Nishat <kamran.nishat@gmail.com>
> wrote:
>>
>> I was talking about the same one. it was introduced in 802.11e (Tx-OP) not
>> in 802.11n
>>
>> On Thu, Oct 23, 2014 at 7:19 PM, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
>>>
>>> Dear Adrian and Kamran,
>>>
>>> Thanks for your replies. I think we are not referring to the same
>>> concept.
>>> Can you please have a look at the attache diagram. I need the middle one
>>> the immediate BA not delayed BA.
>>>
>>>
>>> Thanks,
>>> Ali
>>>
>>>
>>>
>>>
>>> On 14-10-22 11:18 PM, Adrian Chadd wrote:
>>>>
>>>> I don't think mac80211 supports delayed-BA. :(
>>>>
>>>>
>>>> -adrian
>>>>
>>>>
>>>> On 22 October 2014 08:38, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
>>>>>
>>>>> Hello,
>>>>>
>>>>> I am interested to know if we can send multiple packets
>>>>> (non-aggregated,
>>>>> single packets) and then ask
>>>>> for a block ACK? I like to know if this functionality has been
>>>>> implemented in ath9k or if
>>>>> it is possible to achieve this with slight code modifications.
>>>>>
>>>>> What I need:
>>>>> Frame-SIFS-Frame-SIFS-Frame-SIFS-REQ Block ACK-SIFS-Block ACK
>>>>>
>>>>> Best,
>>>>> Ali
>>>>> _______________________________________________
>>>>> ath9k-devel mailing list
>>>>> ath9k-devel@lists.ath9k.org
>>>>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>>>
>>>
>>
>
>
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
