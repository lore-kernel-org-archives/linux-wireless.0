Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34967 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbZBDTkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 14:40:33 -0500
Received: by ewy14 with SMTP id 14so3787376ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 11:40:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cf70f0210902041119l21631fd4hcde779bfca198e24@mail.gmail.com>
References: <cf70f0210902041010h24932f9ao3e5c9f6a243b483d@mail.gmail.com>
	 <3ace41890902041018mdc6a5eanc79cebeb5759001e@mail.gmail.com>
	 <cf70f0210902041119l21631fd4hcde779bfca198e24@mail.gmail.com>
Date: Wed, 4 Feb 2009 19:40:30 +0000
Message-ID: <3ace41890902041140r6c010addkd52c2639d784f384@mail.gmail.com> (sfid-20090204_204058_993847_3041A89E)
Subject: Re: Regarding Belkin wireless USB adapter
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Shivdas Gujare <shivdas.tech@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 4, 2009 at 7:19 PM, Shivdas Gujare <shivdas.tech@gmail.com> wrote:
> Hi Hin-Tak,
> Thanks for your quick reply.
>
> I needs to recheck about "open or WEP network", but from properties it says
> "Security->WPA personal".
>  One thing I observed while trying to configure from command line.
> if I do "ifconfig wlan0 up", it doesn't show "RUNNING".
> I can scan the channels using iwlist properly but, assigning access point using
> "iwconfig wlan0 ap access_pt", doesn't work for me and shows "ap not assigned"
>
> Thanks and Regards,
> Shivdas

So is it working - as in, establishing IP connectivity to outside
*through* an access point?
iwlist works regardless of authentication. Also, are you using
NetworkManager or any way using the dbus interface? I think some WPA
authentication info can be stored in gnome session config and passed
via D-bus.
