Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:29117 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYKFNep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 08:34:45 -0500
Received: by wa-out-1112.google.com with SMTP id v27so343461wah.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 05:34:44 -0800 (PST)
Message-ID: <e27b78a40811060534jf290197uc521a88ccd6fba2b@mail.gmail.com> (sfid-20081106_143450_370759_D3787D2F)
Date: Thu, 6 Nov 2008 13:34:43 +0000
From: Keir <keirlawson@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Fwd: debugging 802.11s
In-Reply-To: <e27b78a40811060444y150553a9j81f5b14b84982754@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40811060444y150553a9j81f5b14b84982754@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---------- Forwarded message ----------
From: Keir <keirlawson@gmail.com>
Date: 2008/11/6
Subject: debugging 802.11s
To: devel@lists.open80211s.org


Hello,

I've been trying to set up an 802.11s network (between just two nodes
initially), I have followed the howto at
http://www.open80211s.org/trac/wiki/HOWTO-0.2.1 however when I run "iw
dev mesh station dump" nothing is listed, I've set my machine's IPs to
be 10.0.0.1 and 10.0.0.2 and they both have the same mesh id and on
the default channel (ie I havent specified one).  I'm wondering how I
would start finding out what the problem is? I'm using an ath5k card
with wireless-testing (quite a recent revsion, havent worked out how
to get git to tell me which one exactly!)

Cheers

Keir
