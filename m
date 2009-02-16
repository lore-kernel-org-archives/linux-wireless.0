Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:58639 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZBPXPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 18:15:55 -0500
Received: by ewy14 with SMTP id 14so2086476ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 15:15:53 -0800 (PST)
Message-ID: <4999F3A6.7020208@gmail.com> (sfid-20090217_001601_891907_CBD61A00)
Date: Tue, 17 Feb 2009 00:15:50 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	viktor.ilijasic@gmail.com
Subject: Re: rtl8187 not handling my usb card
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:

 > You might try applying the patch below and rebuilding your kernel.

easier, try:

# modprobe rtl8187
# echo "0x1b75 0x8187" > /sys/bus/usb/drivers/rtl8187/new_id


regards,
-- 
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...
