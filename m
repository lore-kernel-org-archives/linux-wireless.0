Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32967 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab0JZGZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 02:25:04 -0400
Received: by wyf28 with SMTP id 28so4239320wyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 23:25:03 -0700 (PDT)
MIME-Version: 1.0
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Tue, 26 Oct 2010 16:24:42 +1000
Message-ID: <AANLkTinqLcr7OpQZijX70aVE_P8gpUp=6RkozzVZH5Fm@mail.gmail.com>
Subject: Access Channel Utilization
To: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to access the phy-layer stats that were recently added to
cfg80211 and nl80211. I'm using a modified version of iw as per this
patch:
https://dev.openwrt.org/browser/trunk/package/iw/patches/110-survey_phy_stats.patch

Unfortunately, the utilization stats don't appear to be getting sent
back. I'm using ath5k as the underlying driver.

Thanks for the help,

--
Jonathan Guerin
