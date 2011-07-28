Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62054 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab1G1PKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 11:10:00 -0400
Received: by qwk3 with SMTP id 3so1380789qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 08:09:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110728T153639-332@post.gmane.org>
References: <CAEzeFio8D9aKDFX+Wzo0yceWXy_5tDKpLDFzr9FmarTXCHUOQg@mail.gmail.com>
 <CAEzeFirXVu_pwDCb6t=ps4xskc4fFUy9gGECJgK1q7cYhLizVQ@mail.gmail.com>
 <CAEzeFip+PCV4Ccsi6L+RSvrM_86J2=Ps6193WyC0QzVfwe64LQ@mail.gmail.com>
 <CAEzeFiq2FXYKkfXjDtguryniaU7hQkJczLU98V9P3Uv5-D-P3g@mail.gmail.com>
 <CAB=NE6VT_Q5Apb_ZCfK9fSYGDtaUOwmVqeogN8HE6+SgGYek1A@mail.gmail.com>
 <CAEzeFiq5HXyazJfAx3mRV7TBy6CVEivJY63GkF8jnCczGsUK8Q@mail.gmail.com>
 <CAB=NE6WaRyX0yGs=6h6+2V+gUSPHoY19TTHuXBRAWqR9hw+qAw@mail.gmail.com> <loom.20110728T153639-332@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 28 Jul 2011 08:09:39 -0700
Message-ID: <CAB=NE6WgWyc7a++e00Unf4WOqe7WV_D0rDxVfoXsFOXv7rkgOA@mail.gmail.com> (sfid-20110728_171004_240220_9D8A37C8)
Subject: Re: Testing Auto Channel Selection with hostapd in ath5k and ath9k
To: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2011 at 7:02 AM, Swaminathan Vasanth
<swaminathanvasanth.r@gmail.com> wrote:
> Hi guys,
>  Atlast integrated compiled and built a firmware of Openwrt with hostapd ACS :)
> But, the ACS code did not allow any other previous patches already present in
> the Openwrt hostapd trunk to be applied :(

What can I say, return -ENOTMYISSUE; wait until this stuff gets merged upstream.

  Luis
