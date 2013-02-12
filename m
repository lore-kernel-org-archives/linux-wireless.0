Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42407 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab3BLPZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 10:25:46 -0500
Received: by mail-qc0-f174.google.com with SMTP id z24so70398qcq.33
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2013 07:25:45 -0800 (PST)
MIME-Version: 1.0
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Tue, 12 Feb 2013 18:25:16 +0300
Message-ID: <CA+E=qVekDjNovz4rT4eJZTjwJyf5PUdCuaE--kkhdJrxf4BB-g@mail.gmail.com> (sfid-20130212_162550_819494_BA6E97AA)
Subject: Random stall issue with Intel Corporation Centrino Advanced-N 6205
 [Taylor Peak]
To: ilw@linux.intel.com, Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm hitting subj issue, at some random point mentioned card stops
packet processing and stalls,
and I'm getting a lot of "iwlwifi 0000:03:00.0: fail to flush all tx
fifo queues" lines in dmesg.

wpa_supplicant does not even notice that it's disconnected, and does
not try to re-establish wireless connection.

Looks like many users suffer from this issue, please see:
https://bugzilla.kernel.org/show_bug.cgi?id=48921

Looks like there's no fix except disabling 802.11n functionality. It's
not an option, nowadays internet connection is faster than
802.11g speeds.

Can we get any public comment from Intel devs?

Regards
Vasily
