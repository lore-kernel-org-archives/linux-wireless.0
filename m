Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43325 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1GYUeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 16:34:20 -0400
Received: by qwk3 with SMTP id 3so2235626qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 13:34:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEzeFiq2FXYKkfXjDtguryniaU7hQkJczLU98V9P3Uv5-D-P3g@mail.gmail.com>
References: <CAEzeFio8D9aKDFX+Wzo0yceWXy_5tDKpLDFzr9FmarTXCHUOQg@mail.gmail.com>
 <CAEzeFirXVu_pwDCb6t=ps4xskc4fFUy9gGECJgK1q7cYhLizVQ@mail.gmail.com>
 <CAEzeFip+PCV4Ccsi6L+RSvrM_86J2=Ps6193WyC0QzVfwe64LQ@mail.gmail.com> <CAEzeFiq2FXYKkfXjDtguryniaU7hQkJczLU98V9P3Uv5-D-P3g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Jul 2011 13:33:59 -0700
Message-ID: <CAB=NE6VT_Q5Apb_ZCfK9fSYGDtaUOwmVqeogN8HE6+SgGYek1A@mail.gmail.com> (sfid-20110725_223423_162990_74E1F197)
Subject: Re: Testing Auto Channel Selection with hostapd in ath5k and ath9k
To: Swaminathan Vasanth Rajaraman <swaminathanvasanth.r@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 18, 2011 at 2:14 AM, Swaminathan Vasanth Rajaraman
<swaminathanvasanth.r@gmail.com> wrote:
> rajaras1@kesateekkari:/etc/hostapd$ sudo hostapd hostapd.conf
> Configuration file: hostapd.conf
> ACS: automatic channel selection started, this may take a bit
> ACS: offchannel TX support required
> Segmentation fault

Can you test with the latest series I posted?

  Luis
