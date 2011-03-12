Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46368 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1CLJq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Mar 2011 04:46:26 -0500
Received: by qyk7 with SMTP id 7so241912qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Mar 2011 01:46:25 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 12 Mar 2011 10:21:36 +0100
Message-ID: <AANLkTi=WJgbsJontcDSxL39VHHdUxdQGbzmSTJfnDPzX@mail.gmail.com>
Subject: [debloat] Fixup for recent ath5k/ringparam commits?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	bloat-devel@lists.bufferbloat.net,
	Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I saw this fixup patch in addition to the triple-patch [2,3,4] you
recently sent to linux-wireless ML.

"mac80211: fix ftrace build breakage from {set,get}_ringparam"

Might be worth to put an FYI here.

Regards,
- Sedat -

[1] http://git.infradead.org/debloat-testing.git/commit/de7f39e2550286e4a477b4c289f7b1d321b12ae5
[2] https://patchwork.kernel.org/patch/622451/
[3] https://patchwork.kernel.org/patch/622461/
[4] https://patchwork.kernel.org/patch/621781/
