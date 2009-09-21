Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:4947 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZIUHDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 03:03:11 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: getting "ath5k phy0: noise floor calibration timeout"
Date: Mon, 21 Sep 2009 09:02:23 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909210902.23723.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I kept my laptop the week-end on. The devices was unused during
that time. I got a bunch output into my syslog:

Sep 18 17:30:03 laptop kernel: ##HS cfg80211_bss_expire:129 0
Sep 18 17:30:03 laptop kernel: ##HS expire 00:1b:d4:44:35:90
Sep 18 17:30:03 laptop kernel: ##HS expire 00:13:19:80:da:30
Sep 18 17:30:03 laptop kernel: ##HS expire 00:1b:53:11:dc:40
Sep 18 18:15:04 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 18 18:26:12 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 19 11:12:09 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 19 11:29:36 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 19 11:47:57 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 19 12:31:05 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 19 13:06:42 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 19 14:07:51 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 19 14:10:31 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 19 14:12:00 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 20 00:06:20 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 20 07:46:24 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 20 16:36:43 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 20 16:47:43 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 20 16:52:43 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 20 17:01:43 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 20 20:07:57 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 21 06:22:55 laptop last message repeated 2 times
Sep 21 06:26:00 laptop last message repeated 2 times
Sep 21 06:28:26 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 21 06:33:14 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 21 06:38:34 laptop last message repeated 2 times
Sep 21 06:40:21 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 21 06:41:40 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 21 06:43:44 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 21 06:55:17 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 21 07:03:10 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 21 07:04:35 laptop last message repeated 2 times
Sep 21 07:06:11 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 21 07:16:58 laptop kernel: ath5k phy0: noise floor calibration timeout (2412MHz)
Sep 21 07:21:37 laptop last message repeated 2 times

Is this anything where I should care?  Or can I just
ignore that?  If the latter is the case, should I add a
patch that only three consecutive calibration timeouts
produce a message, so that the log doesn't get "spammed" ?

-- 
http://www.holgerschurig.de
