Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n4a.bullet.ukl.yahoo.com ([217.146.183.152]:42783 "HELO
	n4a.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751527AbYLJANJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 19:13:09 -0500
Message-ID: <493F0B11.9030503@yahoo.co.uk> (sfid-20081210_011314_137479_CE755EA0)
Date: Wed, 10 Dec 2008 00:19:29 +0000
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Use usb anchor facilities to manage urbs
References: <493d9c06.XJn1gNkms3JqErgr%Larry.Finger@lwfinger.net> <493DEF32.5070403@yahoo.co.uk> <493E8B27.3000404@lwfinger.net>
In-Reply-To: <493E8B27.3000404@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Hin-Tak Leung wrote:
>> Just built it and using it right now.
> 
> Does this patch have any effect on bugzilla entry
> 11887(http://bugzilla.kernel.org/show_bug.cgi?id=11887)?

No, still requires manually unloading. (i.e. I removed my current 
SUSPEND_MODULES pm defines, and it hangs on suspend). Need to look elsewhere
or fill in some suspend()/resume() routines, I guess.

Hin-Tak

