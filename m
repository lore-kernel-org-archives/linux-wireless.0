Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58377 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYLGLwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 06:52:50 -0500
Date: Sun, 7 Dec 2008 12:03:49 +0100
To: linux-wireless@vger.kernel.org
Subject: compat-wireless-2008-12-06 and =?utf-8?Q?n?=
	=?utf-8?Q?o_member_named_=E2=80=98requeue=E2=80=99?=
Message-ID: <20081207110349.GA11803@gandalf.dynalias.org> (sfid-20081207_125256_357288_A3A15719)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
From: Norbert Preining <preining@logic.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

(please Cc)

I am trying to compile compat-wireless for 2.6.28-rc7, but it bails out
with:
  CC [M]  /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.o
  /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.c: In function=
 =E2=80=98ieee80211_handle_filtered_frame=E2=80=99:
  /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.c:449: error: =
=E2=80=98struct sk_buff=E2=80=99 has no member named =E2=80=98requeue=E2=
=80=99
  /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.c:451: error: =
=E2=80=98struct sk_buff=E2=80=99 has no member named =E2=80=98requeue=E2=
=80=99
  make[3]: *** [/src/wlan/compat-wireless-2008-12-06/net/mac80211/main.=
o] Error


Is there a way to fix that? Thanks

Best wishes

Norbert

-----------------------------------------------------------------------=
--------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Te=
chnology
Debian Developer <preining@debian.org>                         Debian T=
eX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 0=
9C5 B094
-----------------------------------------------------------------------=
--------
LUDLOW (n.)
A wad of newspaper, folded tablenapkin or lump of cardboard put under
a wobbly table or chair to make it stand-up straight. It is perhaps
not widely known that air-ace Sir Douglas Bader used to get about on
an enormous pair of ludlows before he had his artificial legs fitted.
			--- Douglas Adams, The Meaning of Liff
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
