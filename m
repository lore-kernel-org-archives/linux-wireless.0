Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailservices.uwaterloo.ca ([129.97.128.141]:58185 "EHLO
	minos.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752465AbaJXQEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 12:04:14 -0400
Message-ID: <544A7871.7020005@mailservices.uwaterloo.ca> (sfid-20141024_180417_238480_8F60A841)
Date: Fri, 24 Oct 2014 12:04:01 -0400
From: Ali Abedi <a2abedi@uwaterloo.ca>
MIME-Version: 1.0
To: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: strange MPDU loss pattern
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

We study the effects of 802.11n frame aggregation on throughput. We 
noticed a
strange pattern in the MPDU loss within an aggregated frame. It seems 
that the
second half of the MPDUs (those with higher sequence numbers) in an 
aggregated frame
are more likely to be lost. Is this a known fact or is there any 
explanation for it?

For example if 32 frames are aggregated with sequence numbers 100 to 131.
Frames with sequence numbers 100-115 are more likely to be received 
correctly
than 116-131.


Best,
Ali
