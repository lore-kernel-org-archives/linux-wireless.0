Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23106.mail.ird.yahoo.com ([217.146.189.46]:28405 "HELO
	web23106.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756584AbZA0TOU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 14:14:20 -0500
Date: Tue, 27 Jan 2009 19:14:18 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH V2] rtl8187: Fix error in setting OFDM power settings for RTL8187L
To: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <497f52fb.ABh5zgEKaz63Z7Lu%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <611949.95393.qm@web23106.mail.ird.yahoo.com> (sfid-20090127_201425_356575_24C1F103)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 27/1/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> After reports of poor performance, a review of the latest
> vendor driver
> (rtl8187_linux_26.1025.0328.2007) for RTL8187L devices was
> undertaken.
>=20
> A difference was found in the code used to index the OFDM
> power tables. When
> the Linux driver was changed, my unit works at a much
> greater range than
> before. I think this fixes Bugzilla #12380 and has been
> tested by at least
> two other users.
>=20
> Signed-off-by: Larry Finger
> <Larry.Finger@lwfinger.net>
> Tested-by: Mart=EDn Ernesto Barreyro
> <barreyromartin@gmail.com>
> Cc: Stable <stable@kernel.org>

Acked-by; Hin-Tak Leung <htl10@users.sourceforge.net>

I think what this patch does is to bias the odfm power most of the time=
 to the higher end of the acceptable range. (It is clipped to no bigger=
 than the same old max at both places of modification).

Hin-Tak


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
