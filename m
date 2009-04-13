Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23108.mail.ird.yahoo.com ([217.146.189.48]:20137 "HELO
	web23108.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750979AbZDMU30 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 16:29:26 -0400
Message-ID: <42609.6548.qm@web23108.mail.ird.yahoo.com> (sfid-20090413_222930_120948_2E27A78F)
Date: Mon, 13 Apr 2009 20:29:23 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH RFC] rtl8187: Call 8187L variants "RTL8187LvX" rather than  "RTL8187vX"
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

> We call RTL8187B chips "RTL8187BvX"
> (X is the revision), so we should
> call RTL8187L ones "RTL8187LvX", not "RTL8187vX".
>=20
> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

I don't have a preference either way - if any, I would probably prefer =
without the change, or use a space for readability rather than 'L', bec=
ause the 'L' just isn't there most of the time, and there is B (which i=
s similiar but not the same) and SE (which is completely different). It=
 might be worth also to put a space after the B's.

The way that string is currently done is largely inherited from the ven=
dor driver, I think.



     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
