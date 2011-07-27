Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60001 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1G0XCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 19:02:37 -0400
Received: by yxi11 with SMTP id 11so1125697yxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2011 16:02:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WwP+S8f=MFDtuC6a97nZEGak5gfFEy9majqD9KVVSjiw@mail.gmail.com>
References: <CAEzeFio8D9aKDFX+Wzo0yceWXy_5tDKpLDFzr9FmarTXCHUOQg@mail.gmail.com>
 <CAEzeFirXVu_pwDCb6t=ps4xskc4fFUy9gGECJgK1q7cYhLizVQ@mail.gmail.com>
 <CAEzeFip+PCV4Ccsi6L+RSvrM_86J2=Ps6193WyC0QzVfwe64LQ@mail.gmail.com>
 <CAEzeFiq2FXYKkfXjDtguryniaU7hQkJczLU98V9P3Uv5-D-P3g@mail.gmail.com>
 <CAB=NE6VT_Q5Apb_ZCfK9fSYGDtaUOwmVqeogN8HE6+SgGYek1A@mail.gmail.com>
 <CAEzeFiq5HXyazJfAx3mRV7TBy6CVEivJY63GkF8jnCczGsUK8Q@mail.gmail.com>
 <CAB=NE6WaRyX0yGs=6h6+2V+gUSPHoY19TTHuXBRAWqR9hw+qAw@mail.gmail.com>
 <loom.20110727T230512-90@post.gmane.org> <CAB=NE6WwP+S8f=MFDtuC6a97nZEGak5gfFEy9majqD9KVVSjiw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Jul 2011 16:02:17 -0700
Message-ID: <CAB=NE6U3wa88Fk03q7u17WtoJP1QmoSgJ4D27GSs0pBYGBuCTw@mail.gmail.com> (sfid-20110728_010239_982402_9A408A45)
Subject: Re: Testing Auto Channel Selection with hostapd in ath5k and ath9k
To: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 27, 2011 at 4:01 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Wed, Jul 27, 2011 at 2:18 PM, Swaminathan Vasanth
> <swaminathanvasanth.r@gmail.com> wrote:
>> Hi Luis,
>>  Do you maintain any public git for ACS ? If so can you please send the
>> repository ID? Since hostapd of Openwrt uses the hostap git namely
>> git://w1.fi/srv/git/hostap.git for compiling and building, i think that if i can
>> point it to the correct public ACS git, ACS might be integrated with Openwrt.
>>  Thanks
>> BR,
>
> Can't you just point it to a local /home/foo/hostapd/.git  ?

I just have a tree for ACS, with code independent from hostapd, but
nothing for hostapd. If you *really* need this let me know and I can
make one..

  Luis
