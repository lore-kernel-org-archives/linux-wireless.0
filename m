Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42955 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaKHIyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2014 03:54:53 -0500
Received: by mail-wi0-f181.google.com with SMTP id n3so6518541wiv.8
        for <linux-wireless@vger.kernel.org>; Sat, 08 Nov 2014 00:54:52 -0800 (PST)
Message-ID: <545DDA5A.7090102@gmail.com> (sfid-20141108_095511_956103_A774D9EB)
Date: Sat, 08 Nov 2014 09:54:50 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: bob.marcan@gmail.com
CC: Bob Marcan <bob.marcan@lnx.no-ip.org>, info@laptopke.be,
	users@lists.fedoraproject.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Fw: rtl8192eu driver
References: <20141107223058.21d96d2f@smicro-lan.local.lan> <CAF+9+UNVEauKLqUxrje__0eqkD9BjxLNAfkhTN93bq6Et52Ttg@mail.gmail.com>
In-Reply-To: <CAF+9+UNVEauKLqUxrje__0eqkD9BjxLNAfkhTN93bq6Et52Ttg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08.11.2014 08:51, Pomidora Belisima wrote:
> On Fri, Nov 7, 2014 at 10:30 PM, Bob Marcan <bob.marcan@lnx.no-ip.org>
> wrote:
> 
>> Obviously we should avoid this chip.
>> BR, Bob
>>
>> Begin forwarded message:
>>
>> Date: Fri, 07 Nov 2014 11:21:40 -0600
>> From: Larry Finger <Larry.Finger@lwfinger.net>
>> To: Bob Marcan <bob.marcan@gmail.com>
>> Subject: Re: rtl8192eu driver
>>
>>
>> On 11/07/2014 10:30 AM, Bob Marcan wrote:
>>> Hi.
>>> Driver for this chip is not (anymore?) available on the vendor site.
>>> At least not on the official download page.
>>> But it is available on the net.
>>> This is the one which i use on the Fedora 20:
>>>
>> http://users.telenet.be/x86_64/RPMs/dkms-rtl8192eu-4.3.1.1-11320.20140505.src.rpm
>>> Does this chip can be included  in  the mainstream?
>>
>> I do not have any copies of a device with the RTL8192EU chip, thus I
>> would not be able to test any driver. In addition, I have had much
>> negative feedback from users, and little support from the Realtek USB
>> group. For those reasons, I will never work on another Realtek USB
>> driver that does not use mac80211.
>>
>> Perhaps someone else will take that driver, work for hundreds of hours
>> to get it into a form that is acceptable for kernel inclusion, submit
>> it, and then maintain it. I can assure you that I am not the person to
>> do so.
>>
>> Larry
>>
>>
>>
> 
> At least it is good to know.
> 

Also it is very unfortunate to know Realtek relates in such a manner toward its own devices in Linux environment. 
Realtek devices are good devices.

Larry thank you for your hard work so far.

BTW FYI Bob, here you can find my Realtek RTL8188SU review - follows all links
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2014-November/006714.html

In pursuit of "perfect" USB-WiFi device on Linux.


poma


