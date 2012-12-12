Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:60101 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872Ab2LLPMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 10:12:12 -0500
Message-ID: <50C89C8B.6040301@posedge.com> (sfid-20121212_161215_429390_700C0071)
Date: Wed, 12 Dec 2012 20:32:35 +0530
From: Srinivasan B <srinivasanb@posedge.com>
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org
Subject: 802.11h DFS support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
         I was looking for the DFS support in 
mac80211/cfg80211/nl80211/hostapd and observed that the latest 
wireless-testing kernel & hostapd.git does not include support for 802.11h.

         I also referred few patches submitted by Victor Goldenshtein 
which had support for entire DFS operation basing wireless-testing 
kernel. As per my understanding these patches are presently getting 
modified to support new channel-context modifications.

         Could someone confirm if I am right at my understanding.

Thanks & regards,
Srinivasan
