Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out-1.meta.ua ([194.0.131.45]:57137 "EHLO
	smtp-out-1.meta.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab1KCLkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 07:40:19 -0400
Message-ID: <48883.148.106.128.38.1320319313.metamail@webmail.meta.ua> (sfid-20111103_124023_513220_B7C550C4)
Date: Thu, 3 Nov 2011 13:21:53 +0200 (EEST)
Subject: b43 scans wifi networks with old firmware only.
From: "Roman V.Leon." <roman-vl@meta.ua>
To: linux-wireless@vger.kernel.org
Reply-To: roman-vl@meta.ua
MIME-Version: 1.0
Content-Type: text/plain;charset=windows-1251
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gents.
I have problem with b43 driver 5.100.138, it's not scanning networks for
unknown reason. I have broadcom wifi card PCIID is 14e4:4315, linux kern
ver. is 3.0. When i'm trying to launch iwlist scan, i'm getting "no scan
results".

for example:
sudo ifconfig wlan0 up
sudo iwlist wlan0 scan
    No scan results.

With the older driver 5.10.56.2808, i see normal scan results. If you need
any more information, i will send.

-- 
Thanks,
Roman V.Leon.

