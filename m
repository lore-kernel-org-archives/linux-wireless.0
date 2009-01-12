Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43265 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629AbZALUam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:30:42 -0500
Date: Mon, 12 Jan 2009 15:17:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: fix =?utf-8?B?IuKAmGdt?=
	=?utf-8?B?b2Rl4oCZ?= may be used uninitialized" warning
Message-ID: <20090112201711.GC3786@tuxdriver.com> (sfid-20090112_213051_575457_101162CF)
References: <1231789741-13433-1-git-send-email-linville@tuxdriver.com> <1231789741-13433-2-git-send-email-linville@tuxdriver.com> <496BA39F.6040600@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <496BA39F.6040600@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 12, 2009 at 02:10:07PM -0600, Larry Finger wrote:
> John W. Linville wrote:
> > drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_config=
=E2=80=99:
> > drivers/net/wireless/b43/main.c:3264: warning: =E2=80=98gmode=E2=80=
=99 may be used uninitialized
>=20
> What version of gcc generates this warning? Mine (gcc (SUSE Linux)
> 4.3.2) does not.

gcc -v gives "gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)"

--=20
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
