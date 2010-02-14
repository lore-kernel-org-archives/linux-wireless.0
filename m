Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f216.google.com ([209.85.218.216]:40597 "EHLO
	mail-bw0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0BNR5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 12:57:23 -0500
Received: by bwz8 with SMTP id 8so2218063bwz.38
        for <linux-wireless@vger.kernel.org>; Sun, 14 Feb 2010 09:57:21 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 14 Feb 2010 19:57:21 +0200
Message-ID: <912ec82a1002140957p6959c030h2b33fd9646cfd67d@mail.gmail.com>
Subject: good wlan: sniffer that does not need a windows machine ?
From: Neshama Parhoti <pneshama@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

When developing mac80211 stuff, one sometimes need a WLAN packet
sniffer that have more details than a simple packet information (e.g.
info about packet rates, power lvl, etc..) which might need a
dedicated hw sniffer + software (idealy it should support at least 11g
and 11n, but if a hw supporting all four 11a,b,g,n exists in a
reasonable price then why not).

As far as I can see, most of these works only on windows (e.g. the one
that is published on the wireshark site:
http://www.cacetech.com/products/airpcap.html) they might be good, but
that's not my taste.

So - do you know any good solution that runs on linux ? preferably
with open source drivers..

Thanks!
Ohad.
