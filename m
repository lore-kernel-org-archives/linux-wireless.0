Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:35188 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbbF3X5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 19:57:37 -0400
Received: by lagh6 with SMTP id h6so30124038lag.2
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2015 16:57:34 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Jun 2015 16:57:34 -0700
Message-ID: <CAPA_7hazB4hKyNOMd892riL1p4-pqDQEAP=UTS2AofGJy3_21A@mail.gmail.com> (sfid-20150701_015743_034906_DB35FE7C)
Subject: Dual mode operation
From: Stark Pister <stark@cirrent.co>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to figure out how to use virtual interfaces to run my wifi
module in both AP mode and station mode simultaneously. From the
description on this page
(https://wireless.wiki.kernel.org/en/users/documentation/iw/vif) it
would seem this is possible on devices using the mac80211 subsystem,
but from what I have read online it only works with madwifi drivers
which is outdated and abandoned.

Are there other drivers that tap into this capability of mac80211 or
is no one else interested in this? Is the generic nl80211 driver
capable of using this functionality and if so, how do I go about using
it (note that the "AP" and "Station" sections of the above
documentation page are blank)? If not, what would I have to change to
enable the use of this dual mode capability?

-- 
Stark Pister
Software Developer
Cirrent.co
(925) 818-1813
