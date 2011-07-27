Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47593 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1G0Udy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 16:33:54 -0400
Received: by qwk3 with SMTP id 3so1014536qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2011 13:33:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEzeFiq5HXyazJfAx3mRV7TBy6CVEivJY63GkF8jnCczGsUK8Q@mail.gmail.com>
References: <CAEzeFio8D9aKDFX+Wzo0yceWXy_5tDKpLDFzr9FmarTXCHUOQg@mail.gmail.com>
 <CAEzeFirXVu_pwDCb6t=ps4xskc4fFUy9gGECJgK1q7cYhLizVQ@mail.gmail.com>
 <CAEzeFip+PCV4Ccsi6L+RSvrM_86J2=Ps6193WyC0QzVfwe64LQ@mail.gmail.com>
 <CAEzeFiq2FXYKkfXjDtguryniaU7hQkJczLU98V9P3Uv5-D-P3g@mail.gmail.com>
 <CAB=NE6VT_Q5Apb_ZCfK9fSYGDtaUOwmVqeogN8HE6+SgGYek1A@mail.gmail.com> <CAEzeFiq5HXyazJfAx3mRV7TBy6CVEivJY63GkF8jnCczGsUK8Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Jul 2011 13:33:34 -0700
Message-ID: <CAB=NE6WaRyX0yGs=6h6+2V+gUSPHoY19TTHuXBRAWqR9hw+qAw@mail.gmail.com> (sfid-20110727_223358_783046_727CC97C)
Subject: Re: Testing Auto Channel Selection with hostapd in ath5k and ath9k
To: Swaminathan Vasanth Rajaraman <swaminathanvasanth.r@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 27, 2011 at 10:33 AM, Swaminathan Vasanth Rajaraman
<swaminathanvasanth.r@gmail.com> wrote:
> Hi,
>
>  Thanks for the reply. I made it working for ath9k. It works well for it.

Awesome!

>   Currently i am trying to cross compile and integrating it with Openwrt
> firmware for MIPS architecture. Specifically, for Netgear WNDR37000 router
> which uses ath9k driver.

Great.

>   While building the firmware, hostapd uses the source code from the
> repository git://w1.fi/srv/git/hostap.git. Since this repository is not
> having ACS integrated with it, i created a repository with the patched
> version of hostapd and pointed it as a source for Compilation. The
> compilation and building of firmware is successful. But when i look at the
> files of hostapd in the build_dir, acs files are not available.
> Because of it, i am having a doubt weather ACS is actually integrated to the
> firmware.
>
> Do you have any idea regarding it?

Nope, try the openwrt mailing list.

  Luis
