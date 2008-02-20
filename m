Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4739 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933639AbYBTUdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 15:33:32 -0500
Date: Wed, 20 Feb 2008 15:12:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <bruno@thinktube.com>
Subject: Re: ath5k 64 bit warnings
Message-ID: <20080220201244.GB3825@tuxdriver.com> (sfid-20080220_203336_831751_AA5E1F4D)
References: <1203444942.12887.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1203444942.12887.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 19, 2008 at 07:15:42PM +0100, Johannes Berg wrote:
> drivers/net/wireless/ath5k/base.c: In function =E2=80=98ath5k_beacon_=
update_timers=E2=80=99:
> drivers/net/wireless/ath5k/base.c:2186: warning: format =E2=80=98%llx=
=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but ar=
gument 5 has type =E2=80=98u64=E2=80=99
> drivers/net/wireless/ath5k/base.c:2186: warning: format =E2=80=98%llx=
=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but ar=
gument 6 has type =E2=80=98u64=E2=80=99
> drivers/net/wireless/ath5k/base.c: In function =E2=80=98ath5k_intr=E2=
=80=99:
> drivers/net/wireless/ath5k/base.c:2446: warning: format =E2=80=98%llx=
=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but ar=
gument 7 has type =E2=80=98u64=E2=80=99
> drivers/net/wireless/ath5k/debug.c: In function =E2=80=98read_file_ts=
f=E2=80=99:
> drivers/net/wireless/ath5k/debug.c:203: warning: format =E2=80=98%016=
llx=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but=
 argument 4 has type =E2=80=98u64=E2=80=99
> drivers/net/wireless/ath5k/debug.c: In function =E2=80=98read_file_be=
acon=E2=80=99:
> drivers/net/wireless/ath5k/debug.c:274: warning: format =E2=80=98%016=
llx=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but=
 argument 4 has type =E2=80=98u64=E2=80=99
>=20
> please fix by appropriate casts to unsigned long long.

Dave M. posted a fix, I'll send it with the next batch.

--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
