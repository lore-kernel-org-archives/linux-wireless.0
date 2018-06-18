Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34921 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935544AbeFRTXB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 15:23:01 -0400
Received: by mail-wm0-f44.google.com with SMTP id j15-v6so17748400wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2018 12:23:01 -0700 (PDT)
Subject: Re: Atheros AR9462 - 5Ghz not working
To: mgreger@cinci.rr.com, Tom Psyborg <pozega.tomislav@gmail.com>
References: <20180618135329.N2TLO.197792.root@dnvrco-web12>
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        sedat.dilek@gmail.com,
        =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B280692.2060106@broadcom.com> (sfid-20180618_212305_728967_EFAD0784)
Date: Mon, 18 Jun 2018 21:22:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180618135329.N2TLO.197792.root@dnvrco-web12>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Martin

On 6/18/2018 3:53 PM, mgreger@cinci.rr.com wrote:
>
> ---- Tom Psyborg <pozega.tomislav@gmail.com> wrote:
>> Hi
>>
>> Your log only show attemps on ch 2447, Can you try connecting to 5GHz
>> AP? Connect to Hidden Wireless Network option at the bottom of the
>> nm-applet? Running airodump in monitor mode to see if it captures
>> anything? Maybe your laptop's antennas were designed for 2.4G card
>> only but this just dumb guessing...
>>
>
> It won't connect to any 5GHz AP.
> I don't run network manager or Gnome, in fact X11 is not installed on this machine at all.
> I don't think there is such a thing as 2.4GHz vs 5GHz antennas.

Actually there is. At least there are 2.4G specific antennas and 
dual-band antennas.

In 4.11 there have been a couple eeprom related changes dealing with 
endianness of fields in eeprom. Could be those cause a regression for 
you. I don't have the exact sha id of those commits, but I added the 
author to this thread.

Regards,
Arend
