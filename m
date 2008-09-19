Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53765 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYISEny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 00:43:54 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id m8J4ho8W025509
	for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 07:43:51 +0300
Received: from tikku (essapo-nirac25369.europe.nokia.com [10.162.253.69])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id m8J4hBld001556
	for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 07:43:15 +0300
To: linux-wireless@vger.kernel.org
Subject: stlc45xx: mac80211 driver for N800 and N810
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 19 Sep 2008 07:43:10 +0300
Message-ID: <877i98iw4h.fsf@nokia.com> (sfid-20080919_064357_959180_9A8473C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

Nokia yesterday published stlc45xx, which is a mac80211 driver for
N800 and N810. Webpage here:

http://stlc45xx.garage.maemo.org/

The driver has been implemented with support from ST NXP Wireless, the
chip manufacturer for stlc4550 and stlc4560 found in N800 and N810,
respectively.

After the driver has received some serious cleanup I would like to try
to to get it into wireless-testing tree. But I'll send another email
later on.

-- 
Kalle Valo
