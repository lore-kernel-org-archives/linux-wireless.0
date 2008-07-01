Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:46915 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbYGAUCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 16:02:24 -0400
Message-ID: <486A8DA3.7070805@lwfinger.net> (sfid-20080701_220228_332616_79D145EE)
Date: Tue, 01 Jul 2008 15:03:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Compilation warnings for latest wireless-testing
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On x86_64, the latest wireless-testing gets the following warnings:

   CC [M]  net/mac80211/michael.o
net/mac80211/michael.c: In function =E2=80=98michael_mic_hdr=E2=80=99:
net/mac80211/michael.c:35: warning: passing argument 1 of=20
=E2=80=98ieee80211_get_DA=E2=80=99 discards qualifiers from pointer tar=
get type
net/mac80211/michael.c:36: warning: passing argument 1 of=20
=E2=80=98ieee80211_get_SA=E2=80=99 discards qualifiers from pointer tar=
get type
net/mac80211/michael.c:37: warning: passing argument 1 of=20
=E2=80=98ieee80211_get_qos_ctl=E2=80=99 discards qualifiers from pointe=
r target type

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
