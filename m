Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:48703 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3CFHAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 02:00:15 -0500
Received: by mail-we0-f176.google.com with SMTP id s43so7600202wey.35
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 23:00:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20790.56369.998911.884240@gargle.gargle.HOWL>
References: <CAEk6VBHnWn_KF0TJ_vojuOhWFhR6TncAok+B9mqgGzAdC5DzVg@mail.gmail.com>
	<20790.56369.998911.884240@gargle.gargle.HOWL>
Date: Wed, 6 Mar 2013 00:00:13 -0700
Message-ID: <CAEk6VBHTWn8CX7SKNVQz+T+Wqwe9Na=32Lz=+xOdqncNZFhhkQ@mail.gmail.com> (sfid-20130306_080019_139002_76B577B8)
Subject: Re: [ath9k] Recent driver versions break compatibility with AR9285
 for me
From: Nick Thomas <nhomas@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith,

Thanks for the reply!

The latter iwconfig readout is from an old kernel version (3.2.39),
where the card does indeed work. What I wish to report is that in a
more recent kernel version (3.7.10), the card doesn't work (iwconfig
says "no wireless extensions"). It's not a problem for me (I'm happily
using the old kernel), but I thought it was worth reporting.

Some Googling tells me that a number of people have run into similar
problems (kernel versions >=3.3 breaking their AR928X cards). Maybe
you guys have been made aware of this?

https://bbs.archlinux.org/viewtopic.php?pid=1085309

Nick

On Tue, Mar 5, 2013 at 11:03 PM, Sujith Manoharan <sujith@msujith.org> wrote:
> Nick Thomas wrote:
>> When I run the 3.7.10 kernel with the ath9k module loaded, the
>> wireless does not work, and iwconfig wlan0 reports:
>>
>> wlan0:          no wireless extensions.
>>
>> When I run the 3.2.39 kernel, the wireless works, and iwconfig wlan0 reports:
>>
>> wlan0     IEEE 802.11bgn  ESSID:"HardFatCox"
>>           Mode:Managed  Frequency:2.437 GHz  Access Point: 00:22:75:49:42:F7
>>           Bit Rate=48 Mb/s   Tx-Power=15 dBm
>>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>>           Encryption key:off
>>           Power Management:on
>>           Link Quality=50/70  Signal level=-60 dBm
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:23  Invalid misc:11577   Missed beacon:0
>>
>> My best guess is that recent driver revisions broke compatibility with
>> my wireless card.
>
> The card is recognized properly by ath9k, since it is shown in the interface
> list and it's even associated with HardFatCox :)
>
> What doesn't work ?
>
> Sujith
