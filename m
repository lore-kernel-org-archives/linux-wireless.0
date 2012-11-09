Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:33730 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541Ab2KIEzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 23:55:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 08 Nov 2012 20:46:55 -0800
From: vivekanandah@posedge.com
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: requesting information for HT operation element and VHT operation
 element
Message-ID: <362fd28317fd4b767f750ca5ba40cf51@posedge.com> (sfid-20121109_055605_080944_575BF6F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

i am vivek and i was looking through the ieee80211_sta structure.
The HT operation element is not a part of the ieee80211_sta. some of 
the parameters like HT protection bit in the HT operation element might 
be relevant for driver use.

Also, when 11ac is incorporated, some settings such as channel width in 
the VHT operation element may be relevant for the driver use.

should ieee80211_sta structure contain the operation elements for HT 
now and also for VHT later?

can some one kindly help in throwing more light on the matter ?

thanks in advance
best regards
Vivek

