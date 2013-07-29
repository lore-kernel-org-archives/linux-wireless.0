Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:53774 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3G2Ufs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 16:35:48 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH] Bluetooth: btmrvl: add calibration data download support
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1375126147-28642-1-git-send-email-bzhao@marvell.com>
Date: Mon, 29 Jul 2013 13:35:41 -0700
Cc: <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <39BF90E7-8341-412E-A372-6039B703980D@holtmann.org> (sfid-20130729_223552_796919_F6B2AC5A)
References: <1375126147-28642-1-git-send-email-bzhao@marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

> A text file containing calibration data in hex format can
> be provided while loading btmrvl module. The data will be
> downloaded to firmware.
> eg. insmod btmrvl.ko cal_data_cfg=mrvl/bt_cal_data.conf

why is this a module parameter and you do not just request a standard location via request_firmware(). I do not like the module parameter approach.

Regards

Marcel

