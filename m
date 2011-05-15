Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61503 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab1EOWUB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 18:20:01 -0400
Received: by iyb14 with SMTP id 14so3293619iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2011 15:20:00 -0700 (PDT)
Message-ID: <4DD0518D.1090300@lwfinger.net> (sfid-20110516_002007_149804_6D8A52E9)
Date: Sun, 15 May 2011 17:19:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Flaminigo <sunnyiez@gmail.com>
CC: James <bjlockie@lockie.ca>, linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce.ko doesn't work with 802.11n?
References: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com>	<4DCB3DFF.1030809@lockie.ca>	<BANLkTimEWJbgJJOmCjBoNGtFrSFcoE8aWQ@mail.gmail.com>	<4DCE9DB8.7080404@lwfinger.net>	<BANLkTikHk=yVQ64OJKBcC9QtYP6OOGrmPw@mail.gmail.com> <BANLkTi=07Ovr6UcuT6ctG_3NZ7kxFY+txA@mail.gmail.com>
In-Reply-To: <BANLkTi=07Ovr6UcuT6ctG_3NZ7kxFY+txA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2011 04:32 PM, Flaminigo wrote:
> Hi,
>     I have another question. Is it possible to turn of the N network
> ratio on this NIC? My notebook works well in a 802.11 b/g network. If
> I can turn the N network radio off, at least, I can use it now in my
> office building.

If you just connect to a b/g network, it will work. If the office building only 
has what I suspect is an HT40 network, then it will fail.

Did you look at the kernel bugzilla number that I sent to you the other day. It 
has a patch for using the device with an HT40 network. For me, everything else 
(B/G and HT20) worked before.

Larry

