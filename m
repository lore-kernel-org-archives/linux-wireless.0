Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54739 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab0JDB2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Oct 2010 21:28:09 -0400
Received: by wyb28 with SMTP id 28so4478504wyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 03 Oct 2010 18:28:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286045327.11979.263.camel@maxim-laptop>
References: <4CA6B6F9.8080104@candelatech.com> <1286032902.11979.55.camel@maxim-laptop>
 <4CA76A91.9070200@candelatech.com> <1286045327.11979.263.camel@maxim-laptop>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Mon, 4 Oct 2010 11:27:47 +1000
Message-ID: <AANLkTin0G=_JjtDytJYgwYdh=AQZs=S-518XgChA9Voo@mail.gmail.com>
Subject: Re: Can 'iw' show the current tx-power?
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 3, 2010 at 4:48 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Sat, 2010-10-02 at 10:23 -0700, Ben Greear wrote:
>> On 10/02/2010 08:21 AM, Maxim Levitsky wrote:
>> > On Fri, 2010-10-01 at 21:37 -0700, Ben Greear wrote:
>> >> It seems it can set it, but I don't see any command to print out
>> >> the current value?
>> >>
>> >> Thanks,
>> >> Ben
>> >>
>> > This is pretty much last missing feature from iw.
>>
>> Maybe that and current operating transfer rate?  I can't
>> seem to find that anywhere other than 'iwconfig'...
>
> iw wlan0 link shows that.

This does not work in adhoc mode:

# iw dev wlan0 info
Interface wlan0
        ifindex 4
        type IBSS

# iw dev wlan0 link
Not connected.

>
> Best regards,
>        Maxim Levitsky
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks,

--
Jonathan Guerin
