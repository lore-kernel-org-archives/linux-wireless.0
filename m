Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:63104 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543AbaJWDfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 23:35:31 -0400
Received: by mail-oi0-f47.google.com with SMTP id a141so129168oig.34
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 20:35:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=y=dwZjBHqbsqP5cPK+jL91W-OyA7=y8tqowgSLJKAwA@mail.gmail.com>
References: <5447CF6D.3010401@mailservices.uwaterloo.ca>
	<CAJ-Vmo=y=dwZjBHqbsqP5cPK+jL91W-OyA7=y8tqowgSLJKAwA@mail.gmail.com>
Date: Thu, 23 Oct 2014 08:35:30 +0500
Message-ID: <CADxDmp7XcofyAT9sAGBM6yq2FmffmgbKqjiEpc5ZavKDXM9wgQ@mail.gmail.com> (sfid-20141023_053535_821476_F3391133)
Subject: Re: [ath9k-devel] Block ACK without frame aggregation
From: Kamran Nishat <kamran.nishat@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Ali Abedi <a2abedi@uwaterloo.ca>,
	"(ath9k-devel@lists.ath9k.org)" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think you should look in earlier drivers from Atheors. Because this
delayed BA for separate packets was introduced before 802.11n in
802.11e perhaps.

On Thu, Oct 23, 2014 at 8:18 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> I don't think mac80211 supports delayed-BA. :(
>
>
> -adrian
>
>
> On 22 October 2014 08:38, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
>> Hello,
>>
>> I am interested to know if we can send multiple packets (non-aggregated,
>> single packets) and then ask
>> for a block ACK? I like to know if this functionality has been
>> implemented in ath9k or if
>> it is possible to achieve this with slight code modifications.
>>
>> What I need:
>> Frame-SIFS-Frame-SIFS-Frame-SIFS-REQ Block ACK-SIFS-Block ACK
>>
>> Best,
>> Ali
>> _______________________________________________
>> ath9k-devel mailing list
>> ath9k-devel@lists.ath9k.org
>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
