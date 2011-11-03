Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55490 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1KCHgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 03:36:05 -0400
Received: by qabj40 with SMTP id j40so798744qab.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 00:36:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Nov 2011 08:36:04 +0100
Message-ID: <CAFED-jkVtVFBJfDc-18a+RogAFoTVudS9_POjZHFZ=AtBu1p0g@mail.gmail.com> (sfid-20111103_083611_029427_18E6D826)
Subject: mac80211: UAPSD - EOSP bit seems to be not set when send qos null frame
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a question connected with UAPSD implementation.
Seems, mac80211 always clear EOSP bit in ieee80211_set_qos_hdr() fuction.
Is that a problem in mac80211 or this should be handled in different place/way?

BR
Janusz
