Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23106.mail.ird.yahoo.com ([217.146.189.46]:40926 "HELO
	web23106.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751357AbYLNBI7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2008 20:08:59 -0500
Date: Sun, 14 Dec 2008 01:08:56 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Fix error returns
To: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <49444ed4.RHT0goRgzQT9Xfeg%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <159708.24851.qm@web23106.mail.ird.yahoo.com> (sfid-20081214_020901_674584_8C3F9BDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




--- On Sun, 14/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> There are two places in the rtl8187 code where a routine was
> returning zero
> (OK) when it should have been returning an error.
> 
> Signed-off-by: Larry Finger
> <Larry.Finger@lwfinger.net>
>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

obvious changes that should have been there...


      
