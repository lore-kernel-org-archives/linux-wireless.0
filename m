Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23105.mail.ird.yahoo.com ([217.146.189.45]:45765 "HELO
	web23105.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755544AbYLDStj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 13:49:39 -0500
Date: Thu, 4 Dec 2008 18:49:36 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH V2] rtl8187: Improve wireless statistics for RTL8187
To: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <49375ac0.z1uZDBLv3IxmmMgD%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <878078.93089.qm@web23105.mail.ird.yahoo.com> (sfid-20081204_194942_548936_C9C1113D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




--- On Thu, 4/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Larry Finger <Larry.Finger@lwfinger.net>
> Subject: [PATCH V2] rtl8187: Improve wireless statistics for RTL8187
> To: "John W Linville" <linville@tuxdriver.com>
> Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>, "Hin-Tak Le=
ung" <htl10@users.sourceforge.net>, barreyromartin@gmail.com, linux-wir=
eless@vger.kernel.org
> Date: Thursday, 4 December, 2008, 4:21 AM
> The current wireless statistics for the RTL8187 poorly
> indicate the signal
> strength and quality. With testing, I found that the AGC
> value is inversely
> correlated with the strength as in the RTL8187B. By
> implementing a similar
> calculation, much more code becomes common to the two
> devices.
>=20
> Signed-off-by: Larry Finger
> <Larry.Finger@lwfinger.net>
> Tested by: Mart=EDn Ernesto Barreyro
> <barreyromartin@gmail.com>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Looks cleaner.

Hin-Tak


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
