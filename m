Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46446 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab1G0XBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 19:01:43 -0400
Received: by yia27 with SMTP id 27so1428872yia.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2011 16:01:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110727T230512-90@post.gmane.org>
References: <CAEzeFio8D9aKDFX+Wzo0yceWXy_5tDKpLDFzr9FmarTXCHUOQg@mail.gmail.com>
 <CAEzeFirXVu_pwDCb6t=ps4xskc4fFUy9gGECJgK1q7cYhLizVQ@mail.gmail.com>
 <CAEzeFip+PCV4Ccsi6L+RSvrM_86J2=Ps6193WyC0QzVfwe64LQ@mail.gmail.com>
 <CAEzeFiq2FXYKkfXjDtguryniaU7hQkJczLU98V9P3Uv5-D-P3g@mail.gmail.com>
 <CAB=NE6VT_Q5Apb_ZCfK9fSYGDtaUOwmVqeogN8HE6+SgGYek1A@mail.gmail.com>
 <CAEzeFiq5HXyazJfAx3mRV7TBy6CVEivJY63GkF8jnCczGsUK8Q@mail.gmail.com>
 <CAB=NE6WaRyX0yGs=6h6+2V+gUSPHoY19TTHuXBRAWqR9hw+qAw@mail.gmail.com> <loom.20110727T230512-90@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Jul 2011 16:01:23 -0700
Message-ID: <CAB=NE6WwP+S8f=MFDtuC6a97nZEGak5gfFEy9majqD9KVVSjiw@mail.gmail.com> (sfid-20110728_010147_151020_9CB2B23F)
Subject: Re: Testing Auto Channel Selection with hostapd in ath5k and ath9k
To: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 27, 2011 at 2:18 PM, Swaminathan Vasanth
<swaminathanvasanth.r@gmail.com> wrote:
> Hi Luis,
>  Do you maintain any public git for ACS ? If so can you please send the
> repository ID? Since hostapd of Openwrt uses the hostap git namely
> git://w1.fi/srv/git/hostap.git for compiling and building, i think that if i can
> point it to the correct public ACS git, ACS might be integrated with Openwrt.
>  Thanks
> BR,

Can't you just point it to a local /home/foo/hostapd/.git  ?

 Luis
