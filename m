Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:26758 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbYKBVF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 16:05:58 -0500
Received: by yx-out-2324.google.com with SMTP id 8so862558yxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 13:05:56 -0800 (PST)
Message-ID: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com> (sfid-20081102_220602_046736_53F3586B)
Date: Sun, 2 Nov 2008 13:05:56 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: No ProbeResp - assume out of range
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm curious if others are getting this frequently as I am:

No ProbeResp from current AP 00:DE:AD:BE:EE:FF - assume out of range

I get this with ath5k and ath9k, can be triggered easily in ath5k by
doing a lot of consecutive:

iwlist wlan0 scan

I have to check if I can trigger this with ath9k by scanning too. We
were seeing this with ath9k but were thinking it was ath9k related as
it can be triggered on it after doing a large TX. Wondering if this is
more of a generic and mac80211 issue.

  Luis
