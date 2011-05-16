Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39482 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab1EPOya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 10:54:30 -0400
Received: by iyb14 with SMTP id 14so3793978iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 07:54:29 -0700 (PDT)
Message-ID: <4DD13AA2.1000206@lwfinger.net> (sfid-20110516_165443_802373_628BC25D)
Date: Mon, 16 May 2011 09:54:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Flaminigo <sunnyiez@gmail.com>
CC: James <bjlockie@lockie.ca>, linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce.ko doesn't work with 802.11n?
References: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com>	<4DCB3DFF.1030809@lockie.ca>	<BANLkTimEWJbgJJOmCjBoNGtFrSFcoE8aWQ@mail.gmail.com>	<4DCE9DB8.7080404@lwfinger.net>	<BANLkTikHk=yVQ64OJKBcC9QtYP6OOGrmPw@mail.gmail.com>	<BANLkTi=07Ovr6UcuT6ctG_3NZ7kxFY+txA@mail.gmail.com>	<4DD0518D.1090300@lwfinger.net> <BANLkTikRG61T==_K1sYF4bH=8xC8NwYwhA@mail.gmail.com>
In-Reply-To: <BANLkTikRG61T==_K1sYF4bH=8xC8NwYwhA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2011 08:48 AM, Flaminigo wrote:
> I looked the patch you sent me. The patch is applied on 2.6.39-rc1,
> right? I browse the www.kernel.org but I cannot find the source code
> for RC1.
> What should I  do ? Find the RC1 code. Apply your patch. Recompile the
> kernel and install it? I appreciate your help.

At the moment, you should get 2.6.39-rc7 sources, apply the patch, and build 
that kernel. The patch should apply for any of the ...39-rcX kernels, but I did 
in fact test it with rc7.

Larry

