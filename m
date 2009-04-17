Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([207.115.11.51]:62281 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760324AbZDQAjG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 20:39:06 -0400
Message-ID: <49E7CF98.3000001@lwfinger.net> (sfid-20090417_023912_133730_30A574AE)
Date: Thu, 16 Apr 2009 19:38:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT/RFC V4] rtl8187: Implement TX/RX blink for LED
References: <169050.10379.qm@web23103.mail.ird.yahoo.com>
In-Reply-To: <169050.10379.qm@web23103.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> So there is going to be a V5? V4 tested ok here - I mean it doesn't break anything, since my device is built-in and doesn't have an LED. I'll have a tested-by or acked-by - I think acked-by is the minimal "okay, your e-mail didn't get lost" thing. 
> 

No, I think that it is ready to be submitted. I also checked that it compiles OK
when the conditions are such that CONFIG_RTL8187_LED is not defined.

Do we have any information on how that radio LED is activated on your device?
Presumably, that customer code of 0xo4 has some significance. Do you have a
radio on/off switch, or how is it activated. I know that Johannes is working on
the rfkill setup on Toshiba notebooks. Perhaps that will show something. When he
has that ready, I'll send you a patch to see if we get any events through a
radio LED when the radio is activated/deactivated.

Larry

