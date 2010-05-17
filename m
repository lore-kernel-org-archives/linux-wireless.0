Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:63492 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0EQJhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 05:37:16 -0400
Received: by ewy8 with SMTP id 8so1748539ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 02:37:14 -0700 (PDT)
From: Valentin Manea <valentin.manea@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: AR9170 - Recovering broken frames from MAC
Date: Mon, 17 May 2010 12:37:12 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005171237.12415.linux-wireless@mrs.ro>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

  I'm working on a project with some ar9170 USB devices and I am interested in recovering broken frames from the MAC, basically I would like to get any received frame whoever broken to the driver.
  I've seen in the ar9170usb driver a register called *AR9170_MAC_REG_FRAMETYPE_FILTER* but only some of the bits are documented.

  I've heard that this is totally possible with other Atheros MACs, so could it be implemented with the AR9170?

Thanks,
Valentin
