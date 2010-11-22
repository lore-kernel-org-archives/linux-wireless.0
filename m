Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58805 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab0KVTqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 14:46:13 -0500
Received: by fxm13 with SMTP id 13so2985547fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 11:46:12 -0800 (PST)
Message-ID: <4CEAC868.9040402@lwfinger.net>
Date: Mon, 22 Nov 2010 13:45:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Klaas De Craemer <klaasdc@gmail.com>
CC: htl10@users.sourceforge.net, linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
References: <4CEA9903.6070604@lwfinger.net> <370521.43644.qm@web29514.mail.ird.yahoo.com> <AANLkTimd0EDGtZFcrhknyacoCQQZNMEKe-kvYNA9z_Bo@mail.gmail.com>
In-Reply-To: <AANLkTimd0EDGtZFcrhknyacoCQQZNMEKe-kvYNA9z_Bo@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2010 01:13 PM, Klaas De Craemer wrote:
> Not sure if you meant this, but the box itself is inside (warm), only
> the transceiver is outside.
> Just to be sure, I skipped trying it in Linux first today and
> immediately plugged it in my Windows laptop: instant connection. Next
> I plugged it in Linux and it works fine. This way the device had no
> time to "warm up" because of first being powered in Linux.
> 
> I cannot easily take it inside without unscrewing the antenna (a dish
> with biquad feeder). So I'll try it without antenna tomorrow.

If it is not too much trouble, please try it with the transceiver box warm. In
the meantime, I will do a USB dump of rtl8187 and the Windows driver using an XP
system that I have as a VM. Please check in the device manager on your Windows
box and get the driver version.

Thanks,

Larry
