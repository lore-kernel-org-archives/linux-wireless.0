Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:64674 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZIGPLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 11:11:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 074AB5000E
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2009 17:11:43 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g8MheOz76d0k for <linux-wireless@vger.kernel.org>;
	Mon,  7 Sep 2009 17:11:42 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F8D06.dip0.t-ipconnect.de [217.95.141.6])
	by mx51.mymxserver.com (Postfix) with ESMTP id A48405000B
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2009 17:11:42 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 0651C1E004F
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2009 17:11:33 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: iw: strange output
Date: Mon, 7 Sep 2009 17:11:18 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909071711.18632.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using

* wpasupplicant: hostap_0_6_7-490-g52eb293
* iw: v0.9.17-1-gdbaabba
* linux-wl: v2.6.31-rc8-34797-g4910edb
* some ath5k.ko supported card


For wpa_supplicant, I'm currently using the wext driver.

When I associate while "iw event" is running, I see the following
strange output:

eth1 (phy #0): scan finished: 2412, "g\xc6isQ\xffJ\xec)\xcd\xba\xab\xf2\xfb\xe3F|\xc2T\xf8\x1b\xe8\xe7\x8dvZ.c3\x9f\xc9\x9a"

Is that garbage at the end intentional?




P.S.: when I'm using nl80211 driver for wpa_supplicant, I seem
to be associated, but no ping goes throught.

-- 
http://www.holgerschurig.de
