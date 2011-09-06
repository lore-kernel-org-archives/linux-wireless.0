Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9627 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab1IFIkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 04:40:33 -0400
Message-ID: <4E65DC7D.70306@qca.qualcomm.com> (sfid-20110906_104037_973452_28D96118)
Date: Tue, 6 Sep 2011 11:40:29 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: How to request firmware during module init?
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

ath6kl needs to request the firmware from user space during module init
(or to be exact from sdio probe, but it's almost the same thing) and
boot hardware to get some settings etc before it registers itself to
cfg80211. What's the proper way to handle this?

I noticed that when I compile ath6kl into kernel boot fails on my x86
box as firmware is not available because user space is not ready.

Kalle
