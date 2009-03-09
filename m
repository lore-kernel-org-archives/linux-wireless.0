Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:64996 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbZCIIe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 04:34:58 -0400
Received: by yx-out-2324.google.com with SMTP id 8so942303yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 01:34:55 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 9 Mar 2009 10:34:55 +0200
Message-ID: <55c333c0903090134o4c6c65b7v4bf0674971f9156c@mail.gmail.com> (sfid-20090309_093503_700141_30432BA0)
Subject: Packet aggregation in iwlwifi drivers
From: Kevin Wilson <wkevils@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
- I have a short question about packet aggregation in iwlwifi drivers which
support 802.11n:
Is packet aggregation in these drivers performed by the firmware ?

I noticed that the ampdu_action() function is implemented by
iwl_mac_ampdu_action()
in these drivers; but as far as I can find, only the operations of
start/stop tx and rx aggregation
are implemented in the driver, so I guess that the aggregation of MPDU packets
(concatenating them into a single block, sending BAR - block
acknowledge request,
sending the block containing aggregated MPDUs, and so on) are
implemented in firmware. Is it so ?


Regards,
Kevin
