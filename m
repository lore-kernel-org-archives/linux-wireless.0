Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:34572 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbbEOGsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 02:48:13 -0400
Received: by laat2 with SMTP id t2so104759546laa.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2015 23:48:11 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 May 2015 09:48:11 +0300
Message-ID: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com> (sfid-20150515_084819_998708_F401717F)
Subject: mac80211 drops packet with old IV after rekeying
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Someone opened a bug [1] about Intel devices. He reports that we drop
packets after rekeying. I am not an expert about all the security
stuff, but the submitter says that the bug occurs on any mac80211
device. The AP is running openWRT.

I don't really have the time to learn all the security stuff, so I
thought I'd let everybody know about this bug since after all, it is
affecting all mac80211 devices. Not sure at all the bug is in
mac80211, it might very well be in the AP.

The submitter invested lots of time in root causing the bug including
patching wireshark to have it decrypt packets after rekeying.

I'd be glad if someone could take a look. If not, I'll have someone
from our team to look at it, but I don't know how long it will take...

Thanks.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=92451

Emmanuel Grumbach
egrumbach@gmail.com
