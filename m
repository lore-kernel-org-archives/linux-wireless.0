Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([207.115.11.54]:48382 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbZCYDd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 23:33:28 -0400
Message-ID: <49C9A5D8.20408@lwfinger.net> (sfid-20090325_043330_877561_0666AAC4)
Date: Tue, 24 Mar 2009 22:32:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/3] p54: more SoftLED updates
References: <200903250312.18264.chunkeey@web.de>
In-Reply-To: <200903250312.18264.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch hopefully finishes the SoftLED code:
> - It adds two more LEDs (rx and radio). 
>   (the FW claims it can support up to 16 LEDs,
>    but I doubt that any vendor put more than 4 on a board)
> - update the LEDs in a _delayed_ workqueue.
>   No one reported any more crashes. 
>   (see: "PATCH] p54: fix race condition in memory management")
>   So we can stop burning the mm code.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---

My device has 2 LED's - one for power and one blinks on TX(?). No messages in logs.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
