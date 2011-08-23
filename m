Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:37939 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751643Ab1HWPex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 11:34:53 -0400
Received: by mail-bw0-f50.google.com with SMTP id zu5so230645bkb.37
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 08:34:51 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] wl12xx: some improvements in scheduled scan support
Date: Tue, 23 Aug 2011 18:34:43 +0300
Message-Id: <1314113685-27437-1-git-send-email-coelho@ti.com> (sfid-20110823_173500_859166_E7A448AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are a couple of patches to improve support for scheduled scan in wl12xx.
With these patches we add support for more than one SSID in scheduled scans.

Cheers,
Luca.

Luciano Coelho (2):
  wl12xx: add support for multiple SSIDs in sched_scan
  wl12xx: use SCAN_SSID_TYPE_PUBLIC when using the wildcard in
    sched_scan

 drivers/net/wireless/wl12xx/main.c |    2 +-
 drivers/net/wireless/wl12xx/scan.c |   66 ++++++++++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 8 deletions(-)

