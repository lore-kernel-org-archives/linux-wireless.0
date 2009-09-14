Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f191.google.com ([209.85.210.191]:36905 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbZINM63 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 08:58:29 -0400
Received: by yxe29 with SMTP id 29so3753508yxe.16
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 05:58:33 -0700 (PDT)
Message-ID: <4AAE3DF7.7060504@lwfinger.net>
Date: Mon, 14 Sep 2009 07:58:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vignette consultant <vignette75@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8187B wireless driver issue
References: <3b0e19890909122130l6c447e40r977f050e1a099794@mail.gmail.com>
In-Reply-To: <3b0e19890909122130l6c447e40r977f050e1a099794@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vignette consultant wrote:
>  Larry,
> 
>  I am using Ubuntu 9.0.4 server edition with kernel image 2.6.30.05
> using rtl8187.ko driver module for RTL8187 wireless adapter.
> 
>  It always reports "wlan0 link not ready" error causing not able to
> use wireless connection at all while trying to get dhcp ip lease. I
> also get the same "eth0 link not ready" error.
> 
>  Can you advise of any solution?
> 
>  PS - I get the same error with Ubuntu 2.6.28-11 server kernel image
> also. I even reinstall it, but no luck so far. It gives me same error
> even if I turn off wireless radio!

Please post any messages to the wireless list. That way the general
community can learn and participate, particularly when I get it wrong.

The usual reason for the "link not ready" message is that the network
is down. How are you controlling the network? For wireless, that
message can come from the rfkill switch being off; however, that
functionality is not implemented in 2.6.30 for rtl8187.

Larry


