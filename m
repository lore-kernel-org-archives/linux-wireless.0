Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:47855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764024AbXGTUmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 16:42:47 -0400
Received: by ug-out-1314.google.com with SMTP id j3so686872ugf
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2007 13:42:46 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rt2x00: fix build break from (struct interface *)->id typo
Date: Fri, 20 Jul 2007 22:44:47 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <20070720184742.GI7428@tuxdriver.com>
In-Reply-To: <20070720184742.GI7428@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200707202244.47334.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>   CC [M]  drivers/net/wireless/mac80211/rt2x00/rt2x00mac.o drivers/ne=
t/wireless/mac80211/rt2x00/rt2x00mac.c: In function =E2=80=98rt2x00_tx_=
rts_cts=E2=80=99:
> drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c:60: error: =E2=80=98=
struct interface=E2=80=99 has no member named =E2=80=98if_id=E2=80=99
> drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c:64: error: =E2=80=98=
struct interface=E2=80=99 has no member named =E2=80=98if_id=E2=80=99
> make[3]: *** [drivers/net/wireless/mac80211/rt2x00/rt2x00mac.o] Error=
 1

He, I had to double check where this error came from since it isn't pre=
sent in the rt2x00.git repository,
but I apparently I never checked the "mac80211: improved short preamble=
 handling" patch completely
for the rt2x00 bit. ;)

> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> FYI...already committed to wireless-dev tree.

Thanks :)

Ivo


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
