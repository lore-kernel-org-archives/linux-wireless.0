Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out28.alice.it ([85.33.2.28]:2505 "EHLO
	smtp-out28.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbYBUBMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 20:12:14 -0500
From: Matteo Croce <matteo@openwrt.org>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: airo WPA
Date: Thu, 21 Feb 2008 01:55:52 +0100
Cc: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>,
	Matthieu Castet <castet.matthieu@free.fr>,
	Fabrice Bellet <fabrice@bellet.info>,
	"John W. Linville" <linville@tuxdriver.com>,
	PReDaCoN <alessandroferrari@gmail.com>,
	Benjamin Reed <breed@users.sourceforge.net>,
	Javier Achirica <achirica@users.sourceforge.net>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	linux-wireless@vger.kernel.org, linux-net@vger.kernel.org
References: <200711070307.09832.rootkit85@yahoo.it> <200711071559.47916.rootkit85@yahoo.it> <1194448388.23721.0.camel@localhost.localdomain>
In-Reply-To: <1194448388.23721.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200802210155.53337.matteo@openwrt.org> (sfid-20080221_011219_878716_D79DE970)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il Wednesday 07 November 2007 16:13:08 Dan Williams ha scritto:
> Well, ideally we push the patch upstream and then people can send
> updates to this list... =C2=A0I think it's really close and I feel li=
ke it
> can be submitted for 2.6.25.
>=20
> Dan

I've seen so many updates in GIT, so I applied all up to 3eb9b41f...ae9=
e76e4 to my 2.6.24 kernel and it compiles, loads and runs fine, but the=
re are no WPA commits.
Where is the WPA version that should go in 2.6.25? There are repository=
 or patches floating around? I offer myself as betatester, I'm really i=
nterested in this.

Cheers,
Matteo Croce
--=20
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 KAMIKAZE (bleeding edge) -----------------------
  * 10 oz Vodka       Shake well with ice and strain
  * 10 oz Triple sec  mixture into 10 shot glasses.
  * 10 oz lime juice  Salute!
 ---------------------------------------------------
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
