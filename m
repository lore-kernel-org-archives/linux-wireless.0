Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37987 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1GYBNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2011 21:13:17 -0400
Received: by iyb12 with SMTP id 12so4036921iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jul 2011 18:13:17 -0700 (PDT)
Message-ID: <4E2CC32C.4050201@lwfinger.net> (sfid-20110725_031326_081284_833846AB)
Date: Sun, 24 Jul 2011 20:13:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: ZacapuESL M <zacapu.esl@hotmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u driver
References: <BLU162-w251D59CF638656FD9D960787310@phx.gbl>
In-Reply-To: <BLU162-w251D59CF638656FD9D960787310@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/22/2011 09:42 PM, ZacapuESL M wrote:
> Larry,
> I'm hoping you can/will help me. I bought an Ansel wireless usb card here in
> Mexico. It's a Realtek from what I can gather. The company has a Powerpoint
> presentation for installing Linux drivers. It doesn't work for me. I know
> nothing about programming but love Linux Mint. The Powerpoint says i386, but the
> computer I'm trying to install on is an AMD duo 64. Will that driver work? The
> Powerpoint is written for Fedora but as mentioned I'm using Mint. I don't know
> if there is other syntax but once I get to the 'ismod 8712u.ko' the computer
> locks up. In 'Hardware Drivers' the computer shows I have an rtl871x (written by
> Mint) driver activated but can't find it or figure out how to get it to
> recognize the usb card. Any help is greatly appreciated.
> Leif

I need two pieces of information: (1) The USB IDs as shown by lsusb, and (2) the 
kernel version as shown by 'uname -r'.

Larry


