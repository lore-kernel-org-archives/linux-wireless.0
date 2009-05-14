Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:47327 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbZENAHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 20:07:33 -0400
Received: by wf-out-1314.google.com with SMTP id 26so615427wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 17:07:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242258469.3241.19.camel@maxim-laptop>
References: <1241499867.4816.18.camel@maxim-laptop> <1242149671.5210.2.camel@maxim-laptop>
	<43e72e890905121500k61545ff3mcdf099a08178b72c@mail.gmail.com>
	<1242166051.26484.7.camel@maxim-laptop> <43e72e890905131428r568e6f5eyd64566e993c83d8c@mail.gmail.com>
	<1242256104.3241.4.camel@maxim-laptop> <43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com>
	<1242256950.3241.13.camel@maxim-laptop> <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com>
	<1242258469.3241.19.camel@maxim-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 13 May 2009 17:07:15 -0700
Message-ID: <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com>
Subject: Re: [BUG] Crda oopses the system
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 4:47 PM, Maxim Levitsky <maximlevitsky@gmail.co=
m> wrote:
> On Wed, 2009-05-13 at 16:28 -0700, Luis R. Rodriguez wrote:
>> On Wed, May 13, 2009 at 4:22 PM, Maxim Levitsky <maximlevitsky@gmail=
=2Ecom> wrote:
>> > On Wed, 2009-05-13 at 16:12 -0700, Luis R. Rodriguez wrote:
>> >> On Wed, May 13, 2009 at 4:08 PM, Maxim Levitsky <maximlevitsky@gm=
ail.com> wrote:
>> >> > On Wed, 2009-05-13 at 14:28 -0700, Luis R. Rodriguez wrote:
>> >>
>> >> >> Anyway please try the patches I posted and I'll finish reviewi=
ng this
>> >> >> in the meantime.
>> >> > I don't see anything yet.
>> >>
>> >> wget this and git am it, it has all the patches:
>> >>
>> >> http://bombadil.infradead.org/~mcgrof/patches/wl/race-fixes-2009-=
05-13.patch
>> >>
>> >> =C2=A0 Luis
>> >
>> >
>> > Thanks a lot.
>> > I will test this as soon as be at university again. (next sunday).
>>
>> Oh wow, that seems like eons to me. Hm.. =C2=A0yeah oh well.
> For me it isn't... I have a pile of homeworks....
>
> Anyway, I was supposed to be at lectures tomorrow, but there will be =
'a
> student day', which I obviously don't attend, only to continue linux
> hacking...
>
> So thanks,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Maxim Levitsky
>
> I wish I had time to set up, an ath5k in AP mode. There are rumors th=
at
> it works more or less now, then I could use the same beacon frame to
> test.

It does and if it doesn't its a bug.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
