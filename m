Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3093 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068AbYBEVDa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 16:03:30 -0500
Date: Tue, 5 Feb 2008 15:54:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [PATCH 1/1] mac80211: fix mis-match in {test,set}_bit
	qdisc_pool
Message-ID: <20080205205453.GJ4252@tuxdriver.com> (sfid-20080205_210336_667457_35059EC4)
References: <12020756782190-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <12020756782190-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 03, 2008 at 11:54:38PM +0200, Tomas Winkler wrote:
> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>=20
> This patch fixes a mis-match in {test,set}_bit for qdisc_pool created=
 by
> the move to an array of bits.
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

  CC [M]  net/mac80211/wme.o
net/mac80211/wme.c: In function =E2=80=98wme_qdiscop_enqueue=E2=80=99:
net/mac80211/wme.c:161: warning: passing argument 2 of =E2=80=98constan=
t_test_bit=E2=80=99 makes pointer from integer without a cast
net/mac80211/wme.c:161: warning: passing argument 2 of =E2=80=98variabl=
e_test_bit=E2=80=99 makes pointer from integer without a cast
net/mac80211/wme.c:194: warning: passing argument 2 of =E2=80=98constan=
t_test_bit=E2=80=99 makes pointer from integer without a cast
net/mac80211/wme.c:194: warning: passing argument 2 of =E2=80=98variabl=
e_test_bit=E2=80=99 makes pointer from integer without a cast
net/mac80211/wme.c: In function =E2=80=98wme_qdiscop_dequeue=E2=80=99:
net/mac80211/wme.c:275: warning: passing argument 2 of =E2=80=98constan=
t_test_bit=E2=80=99 makes pointer from integer without a cast
net/mac80211/wme.c:275: warning: passing argument 2 of =E2=80=98variabl=
e_test_bit=E2=80=99 makes pointer from integer without a cast
net/mac80211/wme.c: In function =E2=80=98wme_qdiscop_init=E2=80=99:
net/mac80211/wme.c:399: warning: passing argument 2 of =E2=80=98set_bit=
=E2=80=99 makes pointer from integer without a cast
net/mac80211/wme.c: In function =E2=80=98ieee80211_ht_agg_queue_add=E2=80=
=99:
net/mac80211/wme.c:660: warning: passing argument 2 of =E2=80=98test_an=
d_set_bit=E2=80=99 makes pointer from integer without a cast
net/mac80211/wme.c:673: error: subscripted value is neither array nor p=
ointer
net/mac80211/wme.c: In function =E2=80=98ieee80211_ht_agg_queue_remove=E2=
=80=99:
net/mac80211/wme.c:693: warning: passing argument 2 of =E2=80=98clear_b=
it=E2=80=99 makes pointer from integer without a cast
make[1]: *** [net/mac80211/wme.o] Error 1
make: *** [net/mac80211/] Error 2

Am I missing something?

John
--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
