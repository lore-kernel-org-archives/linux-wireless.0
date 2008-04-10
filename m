Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:41713 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYDJEnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 00:43:35 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Add Realtek 8187B support
Date: Thu, 10 Apr 2008 01:43:32 -0300
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>
References: <200804081931.07638.herton@mandriva.com.br> <47FD8C0E.3060807@lwfinger.net>
In-Reply-To: <47FD8C0E.3060807@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804100143.32854.herton@mandriva.com.br> (sfid-20080410_054404_822199_0490B897)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Thursday 10 April 2008 00:39:58 Larry Finger escreveu:
> Herton Ronaldo Krzesinski wrote:
> > Hi, this patch (made against wireless-testing repository) adds support for
> > 8187B to the rtl8187 module. 
> 
> I want to give a "heads up" to the users of this driver. This 
> afternoon, I was using flood pings on my RTL8187B at different 
> transmission rates to determine how well the device worked. In the 
> middle of the 3rd test, the device failed, and no longer has the 
> ability to transmit. I have no way of knowing if that was just the 
> time that it failed, or if the driver is overpowering the transmitter. 
> In any case, you should watch for problems.

Can you open your dongle and see if you really have a RTL8187B? (as you
said you had to force the ID). May be it wasn't really a 8187b device but
another variant. I did many tests this week with a 8187b that continues to
work ok.

> 
> Larry
> 

--
[]'s
Herton
