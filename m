Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23103.mail.ird.yahoo.com ([217.146.189.43]:40775 "HELO
	web23103.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750750AbZDMT7l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 15:59:41 -0400
Message-ID: <471624.65405.qm@web23103.mail.ird.yahoo.com> (sfid-20090413_215944_358391_4C67E947)
Date: Mon, 13 Apr 2009 19:59:39 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Remove the "8187B chip detected" message when  probing RTL8187B cards
To: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	=?iso-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




--- On Mon, 13/4/09, G=E1bor Stefanik <netrolller.3d@gmail.com> wrote:

> This message appears to be nothing
> more than a leftover of the
> experimental-8187B era. Also, we print the HW type in the
> hwaddr line,
> making this message reduntant. And it's definitely not
> important
> enough to be a KERN_WARNING.
>=20
> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Indeed - that printk doesn't really say anything useful.


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
