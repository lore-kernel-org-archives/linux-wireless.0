Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35628 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0JDBrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Oct 2010 21:47:07 -0400
Received: by wyb28 with SMTP id 28so4486528wyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 03 Oct 2010 18:47:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010041043.07551.br1@einfach.org>
References: <4CA6B6F9.8080104@candelatech.com> <1286045327.11979.263.camel@maxim-laptop>
 <AANLkTin0G=_JjtDytJYgwYdh=AQZs=S-518XgChA9Voo@mail.gmail.com> <201010041043.07551.br1@einfach.org>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Mon, 4 Oct 2010 11:46:45 +1000
Message-ID: <AANLkTikMHVauosiqRbOw1Dp8JuFS2tpXYd-Hcps_SbPD@mail.gmail.com>
Subject: Re: Can 'iw' show the current tx-power?
To: Bruno Randolf <br1@einfach.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 4, 2010 at 11:43 AM, Bruno Randolf <br1@einfach.org> wrote:
> On Mon October 4 2010 10:27:47 Jonathan Guerin wrote:
>> On Sun, Oct 3, 2010 at 4:48 AM, Maxim Levitsky <maximlevitsky@gmail.com>
> wrote:
>> > On Sat, 2010-10-02 at 10:23 -0700, Ben Greear wrote:
>> >> On 10/02/2010 08:21 AM, Maxim Levitsky wrote:
>> >> > On Fri, 2010-10-01 at 21:37 -0700, Ben Greear wrote:
>> >> >> It seems it can set it, but I don't see any command to print out
>> >> >> the current value?
>> >> >>
>> >> >> Thanks,
>> >> >> Ben
>> >> >
>> >> > This is pretty much last missing feature from iw.
>> >>
>> >> Maybe that and current operating transfer rate?  I can't
>> >> seem to find that anywhere other than 'iwconfig'...
>> >
>> > iw wlan0 link shows that.
>>
>> This does not work in adhoc mode:
>>
>> # iw dev wlan0 info
>> Interface wlan0
>>         ifindex 4
>>         type IBSS
>>
>> # iw dev wlan0 link
>> Not connected.
>
> the TX rate is different for each station (and basically for each individual
> packet too) so it does not make sense to show that for the "link" (what ever
> "link" may mean in the context of ad-hoc...).
>
> iw wlan0 station dump
>
> can show you the last TX rate for each station, but again, the rate can and
> will change on a per-packet basis.
>
> there is no such thing as a "current transfer rate".

With iwconfig, we can set a fixed rate, shouldn't this be what we
expect to see as the 'rate'?

Speaking of, is there a particular reason why we still have to use
iwconfig to set the rate as well?

>
> bruno
>

Thanks,


--
Jonathan Guerin
