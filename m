Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34592 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996Ab2LHKrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2012 05:47:46 -0500
Received: by mail-ie0-f177.google.com with SMTP id k13so5053694iea.22
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2012 02:47:45 -0800 (PST)
MIME-Version: 1.0
From: HariHara Sudhan <hari@emo2.com>
Date: Sat, 8 Dec 2012 16:17:25 +0530
Message-ID: <CADPh3e6rL3V=3Nr4w8P8ZCKeT-VjqT45NHtp_narFsp1kaGjKg@mail.gmail.com> (sfid-20121208_114759_223254_1E51B946)
Subject: ar3012 bluetooth nor working
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've a ar9485 +ar3012 combo card and using .
 Wifi is working fine with ath9k drivers.
But for bluetooth i've enabled BT_ATH3k use in kernel. And it loaded btusb ,
bnep, rfcomm modules. ath3k wasn't comming up, and hcitool scan
results gave me nothing.
rfkill shows both wwifi and bluetooth devices are not blocked.

so it is told in ath3k drivers guide from your website . i've added
the id's in ath3k support list and btusb blacklist.
Now ath3k is loaded when i checked lsmod, and btusb is also loaded .
But now rfkill is not showing bluetooth device and hcitool scan says
"Device Not abailable".
What could be the reason.
BTW blacklist driverinfo i gave was "BTUSB_IGNORE

--
Regards

HariHaraSudhan
