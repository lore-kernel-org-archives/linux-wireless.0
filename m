Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:49889 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZDNAZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 20:25:31 -0400
Message-ID: <49E3D7E9.6090501@lwfinger.net> (sfid-20090414_022534_284133_E93B18AD)
Date: Mon, 13 Apr 2009 19:25:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: htl10@users.sourceforge.net,
	John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH RFC] rtl8187: Call 8187L variants "RTL8187LvX" rather
 than 	"RTL8187vX"
References: <42609.6548.qm@web23108.mail.ird.yahoo.com> <69e28c910904131649s7e735380i10c739d27ad0766f@mail.gmail.com>
In-Reply-To: <69e28c910904131649s7e735380i10c739d27ad0766f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

G=E1bor Stefanik wrote:
> What do you mean by "the 'L' just isn't there most of the time"? AFAI=
K
> there is no RTL8187 chip (without a letter suffix), only RTL8187L,
> RTL8187B and RTL8187SE, and 8187L is not much more common that 8187B,
> to warrant calling it "RTL8187" in any case.
>=20

=46or some reason, that is exactly what the vendor driver does. There a=
re several
places that refer to RTL8187B, but nowhere do they talk about the RTL81=
87. They
do, however, refer to the RTL8187L as the chip name on their Web pile.

Larry


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
