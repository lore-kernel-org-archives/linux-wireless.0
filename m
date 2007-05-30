Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33737 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbXE3Nqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2007 09:46:32 -0400
Message-ID: <465D8033.9020204@garzik.org>
Date: Wed, 30 May 2007 09:46:27 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Please pull 'upstream-fixes' branch of wireless-2.6
References: <20070529183037.GB3496@tuxdriver.com>
In-Reply-To: <20070529183037.GB3496@tuxdriver.com>
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> The following changes since commit c420bc9f09a0926b708c3edb27eacba434=
a4f4ba:
>   Linus Torvalds (1):
>         Linux 2.6.22-rc3
>=20
> are found in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6=
=2Egit upstream-fixes
>=20
> Akinobu Mita (2):
>       ieee80211: fix incomplete error message
>       softmac: alloc_ieee80211() NULL check
>=20
> Bj=F6rn Steinbrink (1):
>       prism54: fix monitor mode oops
>=20
> Brandon Craig Rhodes (1):
>       hostap: Allocate enough tailroom for TKIP

pulled


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
