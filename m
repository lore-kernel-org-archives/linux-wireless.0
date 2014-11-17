Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:41724 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaKQXCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 18:02:54 -0500
Received: by mail-lb0-f170.google.com with SMTP id w7so8207994lbi.15
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2014 15:02:53 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Nov 2014 15:02:52 -0800
Message-ID: <CAJqaZwxC+Us=Vis0gQry_vdF--2SCmW9wej5BY+jAfgeb4U6KQ@mail.gmail.com> (sfid-20141118_000304_099785_38089BD1)
Subject: backports-20141114 ath9k doesn't build for me on Ubuntu LTS 14.04
From: ASIC Felix <ic.felix@gmail.com>
To: linux-wireless@vger.kernel.org, sujith@msujith.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

backports-20141114 ath9k doesn't build for me on Ubuntu LTS 14.04
kernel 3.13.0-39

] make defconfig-ath9k && make -j4

/home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/common-spectral.c:40:5:
error: redefinition of \u2018ath_cmn_process_fft\u2019
 int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct
ieee80211_hdr *hdr,
     ^
In file included from
/home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/common.h:27:0,
                 from
/home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/ath9k.h:27,
                 from
/home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/common-spectral.c:18:
/home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/common-spectral.h:146:19:
note: previous definition of \u2018ath_cmn_process_fft\u2019 was here
 static inline int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv,
                   ^
make[8]: *** [/home/me/Downloads/backports-20141114/drivers/net/wireless/ath/ath9k/common-spectral.o]
Error 1

Felix
