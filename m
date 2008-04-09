Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57258 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbYDIPrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 11:47:00 -0400
Message-ID: <47FCE4ED.9010308@lwfinger.net> (sfid-20080409_164705_167236_9F5BDDC8)
Date: Wed, 09 Apr 2008 10:46:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] Add Realtek 8187B support
References: <200804081931.07638.herton@mandriva.com.br>
In-Reply-To: <200804081931.07638.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Hi, this patch (made against wireless-testing repository) adds support for
> 8187B to the rtl8187 module.

Thanks for your efforts. If this driver had been available two months 
ago, it would have made my life much simpler.

Don't get too discouraged about the negative comments - that kind of 
diligence is what makes Linux so robust, and keeps this open-source 
project from chaos.

Once your patches get more stabilized, I will be submitting one to 
handle my hardware, which is a LevelOne WNC-0301USB. For some reason, 
it has an idProduct code of 0x8187, not 0x8189, and one has to look at 
the iProduct value. For early testing, I am just forcing it to be an 
8187B. For my information, what is the iProduct value for your device?

I did only minimal testing. The USB device was only about 1 meter from 
the AP. It connected with a WPA-encrypted network in about the same 
time as my BCM43xx devices do.

I do have one minor comment - I prefer to see signal and noise values 
in dBm, not as xx/65.

Good job,

Larry
