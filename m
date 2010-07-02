Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhub-lb2.unibe.ch ([130.92.0.83]:38993 "EHLO
	mailhub-lb2.unibe.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab0GBObE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 10:31:04 -0400
Message-ID: <4C2DF5AE.60409@iam.unibe.ch>
Date: Fri, 02 Jul 2010 16:20:30 +0200
From: Zhongliang Zhao <zhao@iam.unibe.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: peter.dely@kau.se, staub@iam.unibe.ch
Subject: How to get the current queue length of a wireless device?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

We are currently porting the Net-X framework [University of Illinois, 
Urbana-Champaign] (multi-channel framework) to recent Linux kernels (>= 
2.6.34) with the new wireless drivers (ath5k etc.).  In corporation with 
University of Karlstad, we have already ported the framework from 2.4 
kernels to 2.6.18 using the madwifi drivers.

Now, we want to produce more generic code and therefore use the new 
wireless drivers / mac80211. The multi-channel framework is based on an 
extension of the net bonding drivers, which combines multiple 
radio/channel pairs to one single virtual device. In order to do the 
scheduling, it requires knowledge about the current queue length of the 
individual wireless device for appropriate scheduling. However, we found 
that "get_tx_stats()" has been removed from mac80211. Which function 
should we use for getting the queue length?

Any comment is welcome.

Thank you very much in advance.

Zhongliang and Thomas

-- 
Zhongliang Zhao, Research Assistant
Institute of Computer Science and Applied Mathematics
University of Bern, Neubrueckstrasse 10, CH-3012 Bern, Switzerland
Email: zhao@iam.unibe.ch
Phone: +41 (0)31 511 2639
Fax: +41 (0)31 631 3261

