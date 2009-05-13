Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44791 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZEMXrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 19:47:55 -0400
Received: by fxm2 with SMTP id 2so982271fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 16:47:54 -0700 (PDT)
Subject: Re: [BUG] Crda oopses the system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com>
References: <1241499867.4816.18.camel@maxim-laptop>
	 <1242140728.5626.3.camel@maxim-laptop>
	 <43e72e890905121024i79f743efo68c858bc0a0939a@mail.gmail.com>
	 <1242149671.5210.2.camel@maxim-laptop>
	 <43e72e890905121500k61545ff3mcdf099a08178b72c@mail.gmail.com>
	 <1242166051.26484.7.camel@maxim-laptop>
	 <43e72e890905131428r568e6f5eyd64566e993c83d8c@mail.gmail.com>
	 <1242256104.3241.4.camel@maxim-laptop>
	 <43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com>
	 <1242256950.3241.13.camel@maxim-laptop>
	 <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 02:47:49 +0300
Message-Id: <1242258469.3241.19.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-13 at 16:28 -0700, Luis R. Rodriguez wrote:
> On Wed, May 13, 2009 at 4:22 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > On Wed, 2009-05-13 at 16:12 -0700, Luis R. Rodriguez wrote:
> >> On Wed, May 13, 2009 at 4:08 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >> > On Wed, 2009-05-13 at 14:28 -0700, Luis R. Rodriguez wrote:
> >>
> >> >> Anyway please try the patches I posted and I'll finish reviewing this
> >> >> in the meantime.
> >> > I don't see anything yet.
> >>
> >> wget this and git am it, it has all the patches:
> >>
> >> http://bombadil.infradead.org/~mcgrof/patches/wl/race-fixes-2009-05-13.patch
> >>
> >>   Luis
> >
> >
> > Thanks a lot.
> > I will test this as soon as be at university again. (next sunday).
> 
> Oh wow, that seems like eons to me. Hm..  yeah oh well.
For me it isn't... I have a pile of homeworks....

Anyway, I was supposed to be at lectures tomorrow, but there will be 'a
student day', which I obviously don't attend, only to continue linux
hacking... 

So thanks,
	Maxim Levitsky

I wish I had time to set up, an ath5k in AP mode. There are rumors that
it works more or less now, then I could use the same beacon frame to
test.


Best regards,
	Maxim Levitsky

