Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53920 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab1EPNsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 09:48:06 -0400
Received: by bwz15 with SMTP id 15so3743605bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 06:48:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD0518D.1090300@lwfinger.net>
References: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com>
	<4DCB3DFF.1030809@lockie.ca>
	<BANLkTimEWJbgJJOmCjBoNGtFrSFcoE8aWQ@mail.gmail.com>
	<4DCE9DB8.7080404@lwfinger.net>
	<BANLkTikHk=yVQ64OJKBcC9QtYP6OOGrmPw@mail.gmail.com>
	<BANLkTi=07Ovr6UcuT6ctG_3NZ7kxFY+txA@mail.gmail.com>
	<4DD0518D.1090300@lwfinger.net>
Date: Mon, 16 May 2011 08:48:04 -0500
Message-ID: <BANLkTikRG61T==_K1sYF4bH=8xC8NwYwhA@mail.gmail.com> (sfid-20110516_154811_366069_184538D5)
Subject: Re: rtl8192ce.ko doesn't work with 802.11n?
From: Flaminigo <sunnyiez@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: James <bjlockie@lockie.ca>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I looked the patch you sent me. The patch is applied on 2.6.39-rc1,
right? I browse the www.kernel.org but I cannot find the source code
for RC1.
What should I  do ? Find the RC1 code. Apply your patch. Recompile the
kernel and install it? I appreciate your help.

Regards
Sunny

On Sun, May 15, 2011 at 5:19 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/15/2011 04:32 PM, Flaminigo wrote:
>>
>> Hi,
>>    I have another question. Is it possible to turn of the N network
>> ratio on this NIC? My notebook works well in a 802.11 b/g network. If
>> I can turn the N network radio off, at least, I can use it now in my
>> office building.
>
> If you just connect to a b/g network, it will work. If the office building
> only has what I suspect is an HT40 network, then it will fail.
>
> Did you look at the kernel bugzilla number that I sent to you the other day.
> It has a patch for using the device with an HT40 network. For me, everything
> else (B/G and HT20) worked before.
>
> Larry
>
>
