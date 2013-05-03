Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55425 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab3ECMsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 08:48:13 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MM800AJ63JX6O90@mailout4.w1.samsung.com> for
 linux-wireless@vger.kernel.org; Fri, 03 May 2013 13:48:11 +0100 (BST)
Received: from CAMNPWMFITZJOH ([106.1.222.14])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MM80017T3K8GZ70@eusync1.samsung.com> for
 linux-wireless@vger.kernel.org; Fri, 03 May 2013 13:48:11 +0100 (BST)
Reply-to: m.fitzjohn@samsung.com
From: Mark Fitzjohn <m.fitzjohn@samsung.com>
To: linux-wireless@vger.kernel.org
Subject: RE: Does mac80211 support use of WIPHY_FLAG_SUPPORTS_FW_ROAM?
Date: Fri, 03 May 2013 13:48:08 +0100
Message-id: <006d01ce47fc$76a61690$63f243b0$%fitzjohn@samsung.com> (sfid-20130503_144817_713432_206EE938)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we'd like to support roaming in our firmware and currently have a mac80211
driver.

I know that we need to set the WIPHY_FLAG_SUPPORTS_FW_ROAMING but I'm not
sure if anything else needs to be signalled (called) in to mac80211?

I've seen calls to cfg80211_roamed_bss which gets the roamed indication out
to the user space but do we need to use this as well?

Can anyone explain?

Thanks
Mark


