Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:55170 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbYJZMwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 08:52:18 -0400
Received: by qw-out-2122.google.com with SMTP id 3so791650qwe.37
        for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2008 05:52:15 -0700 (PDT)
Message-ID: <69e28c910810260552o50c3dcbav6c14f4dc5daff0e9@mail.gmail.com> (sfid-20081026_135223_794076_51C3300B)
Date: Sun, 26 Oct 2008 13:52:15 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "David Shwatrz" <dshwatrz@gmail.com>
Subject: Re: zd1211rw and master mode (was :Best USB wireless interface with Linux?)
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Carlo Nyto" <carlonyto@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <31436f4a0810260226q3528e9deh1e90e48516e7d13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <31436f4a0810260226q3528e9deh1e90e48516e7d13@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 26, 2008 at 10:26 AM, David Shwatrz <dshwatrz@gmail.com> wrote:
> Hello,
>  Does zd1211rw support master mode (which is needed for access point)?
>
> I had problems with it in the past:
> see:
> http://marc.info/?l=linux-wireless&m=122209000105893&w=2
> and the answer:
> http://marc.info/?l=linux-wireless&m=122219434714437&w=2
>
> I want to say that I **did** try the patch with the latest
> linux-wireless-next ; it did *not* work !
>
> when running," iwconfig wlan0 mode master"
> I still get:
> Error for wireless request "Set Mode" (8B06) :
>    SET failed on device wlan0 ; Invalid argument.
>
> So, it seems to me that something else is needed so that  zd1211rw
> will be able to be run in master mode.
>
> I would appreciate if anybody can shed any light on this and
> solve the mystery.
>
> As far as I know, according to the vendors, zd1211 **should**
> support master mode.
>
> Rgs,
> DS
>
>
>
> On Fri, Oct 24, 2008 at 3:57 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Thu, Oct 23, 2008 at 6:03 PM, Carlo Nyto <carlonyto@gmail.com> wrote:
>>> I am looking to choose a USB wireless network interface that works
>>> well under Linux.
>>
>> Atheros zd1211rw:
>> http://wireless.kernel.org/en/users/Drivers/zd1211rw
>>
>> Atheros otus (802.11n, not upstream though):
>>
>> http://wireless.kernel.org/en/users/Drivers/otus
>>
>> * Intersil p54:
>>
>> http://wireless.kernel.org/en/users/Drivers/p54
>>
>> rndis_wlan:
>>
>> http://wireless.kernel.org/en/users/Drivers/rndis_wlan
>>
>> * Marvel usb -- no website
>>
>> I'll be inclined to support zd1211rw due to the amount of time its
>> been in the kernel and the amount of wide testing it has received.
>> Atheros 11n otus is the only 11n usb driver I'm aware of for Linux.
>>
>>  Luis
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Zd1211rw is a mac80211 driver, so you must use hostapd with it.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
