Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45061 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZINObm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 10:31:42 -0400
Received: by fxm17 with SMTP id 17so875704fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 07:31:44 -0700 (PDT)
Message-ID: <4AAE53C8.1060100@lwfinger.net>
Date: Mon, 14 Sep 2009 09:31:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vignette consultant <vignette75@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8187B wireless driver issue
References: <3b0e19890909122130l6c447e40r977f050e1a099794@mail.gmail.com>	 <4AAE3DF7.7060504@lwfinger.net> <3b0e19890909140719y7971c9f4m5fe086a9008fd423@mail.gmail.com>
In-Reply-To: <3b0e19890909140719y7971c9f4m5fe086a9008fd423@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vignette consultant wrote:
>  Hi
> 
>  I just built linux kernel 2.6.31 on ubuntu 9.0.4 2.6.28-11 server.
> The dhcpclient wlan0 still is unable to get ip address.
> 
>  I don't see any message in dmesg log for wlan0. The laptop uses
> RTL8187 built-in usb card.
> 
>  The Vista is able to connect through wireless dhcp without any
> problem. The linux is not.
> 
>  How can I trace the root cause of this issue.

How are you controlling the network? Is it with NetworkManager?

Please post the output of the command 'iwconfig'. If you get a
"command not found" message, you will need to provide the full path
such as /sbin/iwconfig. Also, does scanning work? Use the command
'sudo iwlist scan'. That command may also require a full path.

Larry
