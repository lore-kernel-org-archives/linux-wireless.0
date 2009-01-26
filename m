Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15257 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZAZDqI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 22:46:08 -0500
Subject: Re: [Orinoco-devel] [PATCH] orinoco: checkpatch cleanup
From: Pavel Roskin <proski@gnu.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
In-Reply-To: <200901252308.45889.arvidjaar@mail.ru>
References: <200901252254.32137.arvidjaar@mail.ru>
	 <1232913575.3837.16.camel@johannes.local>
	 <200901252308.45889.arvidjaar@mail.ru>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 25 Jan 2009 22:46:02 -0500
Message-Id: <1232941562.1604.4.camel@dv> (sfid-20090126_044613_692897_98C69895)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-01-25 at 23:08 +0300, Andrey Borzenkov wrote:
> On 25 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 22:59:35 Johannes Ber=
g wrote:
>=20
> > unfortunately, your patch was line-wrapped. Cf.
> > Documentation/email-clients.txt
> >
>=20
> This should be updated to indicate that kmail from KDE4 is broken. I=20
> suspected that but so far it worked.

I suggest that you try STGit.  It sends patches by itself.

Please run the patch itself through checkpatch.  It finds two errors:

ERROR: trailing statements should be on next line
#163: FILE: drivers/net/wireless/orinoco/hermes.c:65:
+                       printk(stuff); } while (0)
+                       printk(stuff); } while (0)
ERROR: do not use assignment in if condition
#698: FILE: drivers/net/wireless/orinoco/orinoco_cs.c:167:
+       if ((last_ret =3D (ret)) !=3D 0) \

total: 2 errors, 0 warnings, 786 lines checked

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
