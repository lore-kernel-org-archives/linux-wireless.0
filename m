Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51785 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1H3HHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 03:07:10 -0400
Received: by mail-vx0-f174.google.com with SMTP id 9so4841150vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 00:07:10 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Aug 2011 15:07:10 +0800
Message-ID: <CAGwCZhrVBr-Kit7h01z_1ME7xdz_yQ+BpV33+deGYA86QSS58g@mail.gmail.com> (sfid-20110830_090714_824720_D273AA05)
Subject: [DEV] modify 802.11 header on BCM4329
From: Hao Han <hhanwm@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I try to modify 802.11 header of tramsitted packets, especially
management frames such as beacons. When the wireless interface works
in master mode (enabled by new firmware named fw_bcm4329_apsta.bin), I
do monitor beacons on air. However, I cannot find the place through
the driver where these beacons are generated and transmitted. Is that
in firmware?

My goal is to modify the value of some exsiting field and add new
fields in beacon. If anyone has such experience, please let me know.
Any feedback would be extremely appreciated :)

Best,
Hao
