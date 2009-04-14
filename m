Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23104.mail.ird.yahoo.com ([217.146.189.44]:35378 "HELO
	web23104.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759413AbZDNSea convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 14:34:30 -0400
Message-ID: <2626.97720.qm@web23104.mail.ird.yahoo.com> (sfid-20090414_203458_345740_BB929A10)
Date: Tue, 14 Apr 2009 18:34:27 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Disable TX retries if IEEE80211_TX_CTL_NO_ACK is set
To: =?iso-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--- On Tue, 14/4/09, Johannes Berg <johannes@sipsolutions.net> wrote:

> On Tue, 2009-04-14 at 20:09 +0200,
> G=E1bor Stefanik wrote:
>=20
> > +        if (!info->flags & IEEE80211_TX_CTL_NO_ACK))
> > +            hdr->retry =3D cpu_to_le32((info->control.rates[0].cou=
nt - 1) << 8);
> > +        else
> > +            hdr->retry =3D 0;
>=20
> Umm. You obviously didn't even _COMPILE_ that patch. Let
> alone test it
> properly.

Yeah, very naughty... patches should at a minimum satisfy the eat-you-o=
ld-dog-food criteria, i.e. work on your own computer and do nothing bad=
 there...



     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
