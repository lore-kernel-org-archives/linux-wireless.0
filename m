Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51743 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab1EPPUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 11:20:24 -0400
Received: by bwz15 with SMTP id 15so3824217bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 08:20:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD13AA2.1000206@lwfinger.net>
References: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com>
	<4DCB3DFF.1030809@lockie.ca>
	<BANLkTimEWJbgJJOmCjBoNGtFrSFcoE8aWQ@mail.gmail.com>
	<4DCE9DB8.7080404@lwfinger.net>
	<BANLkTikHk=yVQ64OJKBcC9QtYP6OOGrmPw@mail.gmail.com>
	<BANLkTi=07Ovr6UcuT6ctG_3NZ7kxFY+txA@mail.gmail.com>
	<4DD0518D.1090300@lwfinger.net>
	<BANLkTikRG61T==_K1sYF4bH=8xC8NwYwhA@mail.gmail.com>
	<4DD13AA2.1000206@lwfinger.net>
Date: Mon, 16 May 2011 10:20:22 -0500
Message-ID: <BANLkTinWLd18arAye-4KVpicoJAqThWoJw@mail.gmail.com> (sfid-20110516_172028_901046_1956FA4E)
Subject: Re: rtl8192ce.ko doesn't work with 802.11n?
From: Flaminigo <sunnyiez@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: James <bjlockie@lockie.ca>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
    I appreciate your help greatly. I am not very familiar with kernel
programming. Actually, I am a graphics guy. I try to apply your patch
but I failed. That was my process. FYI

1. Download RC7 code from
http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.39-rc7.tar.bz2
2. Download the patch from
http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.39-rc7.bz2
3. apply the patch.
sunny@samunder:~/Downloads/kernel/linux-2.6.39-rc7$ bzip2 -dc
patch-2.6.39-rc7.bz2  | patch -p1
4. copy and paste your patch
https://bugzilla.kernel.org/attachment.cgi?id=57802 and place it in
file `pa`
5. apply your patch by patch -p1 < pa.

I failed :(



On Mon, May 16, 2011 at 9:54 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/16/2011 08:48 AM, Flaminigo wrote:
>>
>> I looked the patch you sent me. The patch is applied on 2.6.39-rc1,
>> right? I browse the www.kernel.org but I cannot find the source code
>> for RC1.
>> What should I  do ? Find the RC1 code. Apply your patch. Recompile the
>> kernel and install it? I appreciate your help.
>
> At the moment, you should get 2.6.39-rc7 sources, apply the patch, and build
> that kernel. The patch should apply for any of the ...39-rcX kernels, but I
> did in fact test it with rc7.
>
> Larry
>
>
