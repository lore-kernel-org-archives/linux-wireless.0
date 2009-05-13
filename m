Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:50380 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZEMX3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 19:29:09 -0400
Received: by wf-out-1314.google.com with SMTP id 26so608743wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 16:29:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242256950.3241.13.camel@maxim-laptop>
References: <1241499867.4816.18.camel@maxim-laptop> <1242140728.5626.3.camel@maxim-laptop>
	<43e72e890905121024i79f743efo68c858bc0a0939a@mail.gmail.com>
	<1242149671.5210.2.camel@maxim-laptop> <43e72e890905121500k61545ff3mcdf099a08178b72c@mail.gmail.com>
	<1242166051.26484.7.camel@maxim-laptop> <43e72e890905131428r568e6f5eyd64566e993c83d8c@mail.gmail.com>
	<1242256104.3241.4.camel@maxim-laptop> <43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com>
	<1242256950.3241.13.camel@maxim-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 13 May 2009 16:28:50 -0700
Message-ID: <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com>
Subject: Re: [BUG] Crda oopses the system
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 4:22 PM, Maxim Levitsky <maximlevitsky@gmail.co=
m> wrote:
> On Wed, 2009-05-13 at 16:12 -0700, Luis R. Rodriguez wrote:
>> On Wed, May 13, 2009 at 4:08 PM, Maxim Levitsky <maximlevitsky@gmail=
=2Ecom> wrote:
>> > On Wed, 2009-05-13 at 14:28 -0700, Luis R. Rodriguez wrote:
>>
>> >> Anyway please try the patches I posted and I'll finish reviewing =
this
>> >> in the meantime.
>> > I don't see anything yet.
>>
>> wget this and git am it, it has all the patches:
>>
>> http://bombadil.infradead.org/~mcgrof/patches/wl/race-fixes-2009-05-=
13.patch
>>
>> =C2=A0 Luis
>
>
> Thanks a lot.
> I will test this as soon as be at university again. (next sunday).

Oh wow, that seems like eons to me. Hm..  yeah oh well.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
