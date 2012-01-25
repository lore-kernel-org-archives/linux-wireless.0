Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail12c0.megamailservers.com ([216.251.36.23]:41027 "EHLO
	mail12c0.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab2AYWYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 17:24:24 -0500
Message-ID: <4F207F83.7010601@microhardcorp.com> (sfid-20120125_232428_323116_9158F77F)
Date: Wed, 25 Jan 2012 15:17:39 -0700
From: Bin Zeng <bzeng@microhardcorp.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Is it possible to set ath9k bwmode when in non-HT mode?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Do you know if  it is possible to change ath9k bwmode when hwmode 
setting as non-ht mode?  I guess we can set channelFlags in  struct 
ath9k_channel, right? Any idea is highly appreciated.

Thanks

Binary
