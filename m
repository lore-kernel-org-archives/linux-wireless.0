Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:55334 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbYDISMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 14:12:23 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Add Realtek 8187B support
Date: Wed, 9 Apr 2008 15:12:18 -0300
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>
References: <200804081931.07638.herton@mandriva.com.br> <47FCE4ED.9010308@lwfinger.net>
In-Reply-To: <47FCE4ED.9010308@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804091512.18492.herton@mandriva.com.br> (sfid-20080409_191227_592486_3CFAC678)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Wednesday 09 April 2008 12:46:53 Larry Finger escreveu:
> Herton Ronaldo Krzesinski wrote:
> > Hi, this patch (made against wireless-testing repository) adds support for
> > 8187B to the rtl8187 module.
> 
> Thanks for your efforts. If this driver had been available two months 
> ago, it would have made my life much simpler.
> 
> Don't get too discouraged about the negative comments - that kind of 
> diligence is what makes Linux so robust, and keeps this open-source 
> project from chaos.

Thanks, ok no problem :)

> 
> Once your patches get more stabilized, I will be submitting one to 
> handle my hardware, which is a LevelOne WNC-0301USB. For some reason, 
> it has an idProduct code of 0x8187, not 0x8189, and one has to look at 
> the iProduct value. For early testing, I am just forcing it to be an 
> 8187B. For my information, what is the iProduct value for your device?

Mine here reports iProduct = 2 RTL8187B_WLAN_Adapter
It's a Quanta IL1 mini-notebook with 8187b builtin.

> 
> I did only minimal testing. The USB device was only about 1 meter from 
> the AP. It connected with a WPA-encrypted network in about the same 
> time as my BCM43xx devices do.
> 
> I do have one minor comment - I prefer to see signal and noise values 
> in dBm, not as xx/65.

It's using the same signal/noise reporting as original rtl8187, we can change
it, I also found it was strange this way.

> 
> Good job,
> 
> Larry

--
[]'s
Herton
