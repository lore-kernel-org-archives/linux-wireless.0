Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43341 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab1AGWy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 17:54:27 -0500
Received: by iwn9 with SMTP id 9so17644437iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 14:54:27 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 7 Jan 2011 14:54:05 -0800
Message-ID: <AANLkTingv5Ur6UHeZoKhfYpTUw6wGMK7ULPm7V49UfPn@mail.gmail.com>
Subject: Compat-wireless as is on ChromeOS head 2011-01-07 for ath9k
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Paul Stewart <pstew@google.com>,
	Nael Atallah <Nael.Atallah@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FWIW I've taken a snapshot of today's ChromeOS kernel.git tree and
sucked out any delta from the original compat-wireless-v2.6.36-5-spn
used there on:

net/wireless
net/mac80211/
drivers/net/wireless/ath/

and put it back into a vanilla compat-wireless-v2.6.36-5-spn with
ath9k selected already for driver-select. I figured others might want
to test this for some other reasons so here is the code:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/mods/compat-wireless-2.6.36-5-spn-google-2011-01-07.tar.bz2
sha1sum: 8cd9e5eb74292d23c511cddbf0cb2d26f0451d9a

The hope is the delta + anything else we need for the future will go
into a vanilla -6 release.

  Luis
