Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-4.exch022.serverdata.net ([64.78.56.56]:16400 "EHLO
	HUB022-ca-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760049Ab3DCHnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 03:43:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Date: Wed, 3 Apr 2013 00:35:25 -0700
From: <vivekanandah@posedge.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: question on SMPS for AP
Message-ID: <fbef7a2278fe739a398430949087c950@posedge.com> (sfid-20130403_094335_455663_91C5B552)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

i was looking into the MAC80211 code for Spatial multiplexing Power 
Save handling.

i see that for the station side, the code seems to be handled.
is the same true for an AP interface as well? this is my current 
understanding and i do not see any code handling for AP for SMPS.


 From the perspective of an AP, the only thing it needs to do, is to 
monitor the station for change to dynamic SMPS mode and if the station 
is in dynamic SMPS mode, set the RTS flag for the first packet to be 
sent out to the station so that an RTS/CTS mechanism is employed before 
the packet transfer. this will make the station to wake up its receive 
chains for the impending packet tranfer.

can anyone provide any inputs for the same and direct me to any code 
that will help in understanding SMPS for AP?

thanks in advance
best regards
Vivek



