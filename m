Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54811 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaFBELs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 00:11:48 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so3784678wiw.8
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jun 2014 21:11:47 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 2 Jun 2014 09:41:46 +0530
Message-ID: <CADNhdGERV9fJz5azyBsqr6cUHTk_4Rq_5mF0=7W+SQy12jCCPg@mail.gmail.com> (sfid-20140602_061236_728808_8C19A16B)
Subject: [mac80211] WMM / 802.11e support in transmission
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Assume i have configured the WMM parameters per Access Category, such
as CWmin, CWmax etc.
I believe a frame that needs to be transmitted over a WiFi interface
using mac80211 needs to be given only the 802.3 equivalent frame.
In this case, how does the driver get the priority information to
classify the packet into one of the 4 Access Categories?
Should i transmit a Priority tagged 802.3 packet instead of an
untagged 802.3 packet?

Please clarify.

Would appreaciate if someone could throw some light immediately.

thanks,
-shankar
