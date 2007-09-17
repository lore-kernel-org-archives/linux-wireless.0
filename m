Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4648 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbXIQXlu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 19:41:50 -0400
Date: Mon, 17 Sep 2007 19:05:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH -mm][resend] net/wireless/sysfs.c: Shut up build warning
Message-ID: <20070917230559.GF9282@tuxdriver.com>
References: <alpine.LFD.0.999.0709180412490.8863@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <alpine.LFD.0.999.0709180412490.8863@enigma.security.iitk.ac.in>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 18, 2007 at 04:15:11AM +0530, Satyam Sharma wrote:
>=20
> net/wireless/sysfs.c:108: warning: =E2=80=98wiphy_uevent=E2=80=99 def=
ined but not used
>=20
> when CONFIG_HOTPLUG=3Dn is because the only usage site of this functi=
on
> is #ifdef'ed as such, so let's #ifdef the definition also.
>=20
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

This has already been sent upstream through Dave Miller's net-2.6.24
tree...

John
--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
