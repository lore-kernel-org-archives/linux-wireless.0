Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:47467 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbZKJCQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 21:16:42 -0500
Received: by yxe17 with SMTP id 17so3117195yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 18:16:48 -0800 (PST)
Subject: Re: Changing from Minstrel to PID
From: =?ISO-8859-1?Q?Mart=EDn?= Ernesto Barreyro
	<barreyromartin@gmail.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890911081538u1a6649eybdd38ffe4b0fd6fc@mail.gmail.com>
References: <1257542956.6565.2.camel@localhost.localdomain>
	 <20091106214803.GL2782@tuxdriver.com>
	 <1257548493.3752.15.camel@localhost.localdomain>
	 <3ace41890911070418v1b0fc540v4f620470a21dfebb@mail.gmail.com>
	 <cec7b3dc0911081339g5f838527nf76a15889ecaddbd@mail.gmail.com>
	 <3ace41890911081538u1a6649eybdd38ffe4b0fd6fc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 23:18:23 -0300
Message-ID: <1257819503.13712.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El dom, 08-11-2009 a las 23:38 +0000, Hin-Tak Leung escribió:
> On Sun, Nov 8, 2009 at 9:39 PM, Martín Ernesto Barreyro
> <barreyromartin@gmail.com> wrote:
> 
> >  I don't know, I'll post the minstrel statistics, maybe it'll help you.Some
> > months ago the rate control wasn't working at all, and Larry took care of
> > it. Since that both algorithms started working, the count of retrys was
> > missing at that time.
> > Both algorithms started working, but minstrel sometimes works for while but
> > then goes to the max rate, in my case 54mbps if i a don't change it to other
> > with iwconfig, e.g iwconfig wlan0 rate 11M auto
> 
> I am sure somebody with more experience with tuning mistrel can give
> you some help...
> 
> >> The other thing is, you can probably patch compat-wireless to do
> >> something similiar or at least experiment with it, as long as your
> >> kernel is configured with most of them as modules. Switching
> >> compat-wireless is quite easy, and particularly with the
> >> 'driver-select rtl818x' option you just rebuild about 6 kernel modules
> >> instead of the usual 50+, which makes it quite quick and painless.
> >
> >
> > You are saying that i could give it a try for adding the option that i was
> > asking for?
> > Iill give it a shot but i don't know how many time will it take me
> 
> Yes, compat-wlreless is useful for trying out small patches. Adding a
> module parameter isn't too much trouble, i think - and there are
> plenty of examples (many kernel module do parameters).

I've my 2.31 kernel running (from archlinux repositories) and
compat-wireless 2009-11-06 and now not even with pid i get it working
good. It goes to the max rate available.

>From the distance that I'm from the AP i have to limit the rate to
11Mbps

I'll compile wireless testing and i'll post the statistics, or if
someone tell the information they need to debug it i'll post it.

-- 
Martín Ernesto Barreyro <barreyromartin@gmail.com>
Analista Universitario en Redes de Datos.

