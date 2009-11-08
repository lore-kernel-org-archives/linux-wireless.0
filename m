Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42398 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZKHXh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 18:37:57 -0500
Received: by bwz27 with SMTP id 27so2932519bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 15:38:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cec7b3dc0911081339g5f838527nf76a15889ecaddbd@mail.gmail.com>
References: <1257542956.6565.2.camel@localhost.localdomain>
	 <20091106214803.GL2782@tuxdriver.com>
	 <1257548493.3752.15.camel@localhost.localdomain>
	 <3ace41890911070418v1b0fc540v4f620470a21dfebb@mail.gmail.com>
	 <cec7b3dc0911081339g5f838527nf76a15889ecaddbd@mail.gmail.com>
Date: Sun, 8 Nov 2009 23:38:01 +0000
Message-ID: <3ace41890911081538u1a6649eybdd38ffe4b0fd6fc@mail.gmail.com>
Subject: Re: Changing from Minstrel to PID
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?Mart=EDn_Ernesto_Barreyro?=
	<barreyromartin@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 8, 2009 at 9:39 PM, Martín Ernesto Barreyro
<barreyromartin@gmail.com> wrote:

>  I don't know, I'll post the minstrel statistics, maybe it'll help you.Some
> months ago the rate control wasn't working at all, and Larry took care of
> it. Since that both algorithms started working, the count of retrys was
> missing at that time.
> Both algorithms started working, but minstrel sometimes works for while but
> then goes to the max rate, in my case 54mbps if i a don't change it to other
> with iwconfig, e.g iwconfig wlan0 rate 11M auto

I am sure somebody with more experience with tuning mistrel can give
you some help...

>> The other thing is, you can probably patch compat-wireless to do
>> something similiar or at least experiment with it, as long as your
>> kernel is configured with most of them as modules. Switching
>> compat-wireless is quite easy, and particularly with the
>> 'driver-select rtl818x' option you just rebuild about 6 kernel modules
>> instead of the usual 50+, which makes it quite quick and painless.
>
>
> You are saying that i could give it a try for adding the option that i was
> asking for?
> Iill give it a shot but i don't know how many time will it take me

Yes, compat-wlreless is useful for trying out small patches. Adding a
module parameter isn't too much trouble, i think - and there are
plenty of examples (many kernel module do parameters).
