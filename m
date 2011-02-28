Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59245 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1B1MIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 07:08:37 -0500
Received: by fxm17 with SMTP id 17so3646171fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 04:08:36 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] p54: fix a NULL pointer dereference bug
Date: Mon, 28 Feb 2011 13:08:27 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <1298841562-62496-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1298841562-62496-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281308.27632.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 27 February 2011 22:19:22 Felix Fietkau wrote:
> If the RSSI calibration table was not found or not parsed properly,
> priv->rssi_db will be NULL, p54_rssi_find needs to be able to deal
> with that.

Acked-by: Christian Lamparter <chunkeey@googlemail.com>

Did someone report an oops and if so, what card was it?
And is it possible to get the EEPROM image?

Regards,
	Chr
