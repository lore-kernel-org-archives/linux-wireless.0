Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46433 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaKKKTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 05:19:55 -0500
Received: by mail-pa0-f42.google.com with SMTP id bj1so10346220pad.15
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2014 02:19:55 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 11 Nov 2014 15:49:55 +0530
Message-ID: <CAGKQeFgX+qZ2MSjRio+OKo5GZDzgZCRcZ3d=DAkYWcppC2nG3w@mail.gmail.com> (sfid-20141111_111958_832924_6F9AC449)
Subject: PN KEY MISMATCH: PACKET DROPPED MAC80211
From: deepak kumar Pradhan <hydipu@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are using IXDP465 intel board which is running kernel 3.12.2 with a
wireless >Atheros card (driver ath9k) for mesh networking using authsae for
secured mesh >network.
Under stress tests we are getting gap in wireless connectivity. On further
investigation, we found that the Packet Number and Key is mismatched and
packet >dropped.
(In function: ieee80211_crypto_ccmp_decrypt, file net/mac80211/wpa.c file).
To fix this we tried the below patch, but we still facing the same
issue(gap).
Has someone observed this issue. Any inputs on this is much appreciated.
Please forgive me if I have posted to a wrong list, and please guide me
where should I post this?
