Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:36592 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3ISAmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 20:42:14 -0400
Received: by mail-vb0-f41.google.com with SMTP id g17so6098207vbg.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Sep 2013 17:42:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <523350DC.5050905@lwfinger.net>
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com>
	<522D054B.5060205@lwfinger.net>
	<522DD856.7050309@ilande.co.uk>
	<522DE1BE.6070904@lwfinger.net>
	<522DE8CA.9010008@ilande.co.uk>
	<522DFF83.6000605@lwfinger.net>
	<522E0573.4000804@ilande.co.uk>
	<522E1B7D.5010107@lwfinger.net>
	<522E463E.4040701@ilande.co.uk>
	<522E5416.4010901@lwfinger.net>
	<522E5D83.9060103@ilande.co.uk>
	<522E896E.7000607@lwfinger.net>
	<522EB51A.2080004@ilande.co.uk>
	<522F3757.8030600@lwfinger.net>
	<522F7B61.6060208@ilande.co.uk>
	<5230CDF1.1040905@lwfinger.net>
	<CALa3VXbxQ1Z2J5weV7rQ16c53D1MQyDL1YGQrV6EkCJYfh=uYA@mail.gmail.com>
	<523350DC.5050905@lwfinger.net>
Date: Wed, 18 Sep 2013 20:42:13 -0400
Message-ID: <CALa3VXZ2+7v-0xrWgoPsAjaaybfMUDONZae8bSx4XhAc6h7wUw@mail.gmail.com> (sfid-20130919_024228_011079_75BA371F)
Subject: Re: RTL8192CU continually reconnecting
From: Timothy Rundle <tgrundlesr@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found that if I setup a old wireless router as a repeater and keep
it within 10-12 feet I have a stable connection.  If I move it back to
12-15 the connection becomes less reliable.  Anything past 15 feet is
unusable.

I see there have been lots of conversations on the topic and you are
working on some power management changes.  If you need me to do any
testing let me know.

Timothy

On Fri, Sep 13, 2013 at 1:52 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 09/12/2013 05:24 PM, Timothy Rundle wrote:
>>
>>
>> I finally got some free time to go through all the patches. My results
>> were
>> similar to Mark's, but I do not get the watchdog messages, though I am
>> pretty
>> sure watchdog is disabled on my PC. I did even try installing openSUSE
>> 12.3, but
>> did not have any success.  It didn't even find my wireless network. I
>> manually
>> configured the network via network-manager, but still no luck.
>>
>> Let me know if you need anything else from me.
>
>
> The watchdog in rtl8192cu has nothing to do with any kernel watchdog timers.
> They are totally separate.
>
> Larry
>
>
