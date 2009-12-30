Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54067 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZL3UmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 15:42:23 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so4058353ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2009 12:42:22 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 5/6] rt2x00: Fix LED configuration setting for rt2800.
Date: Wed, 30 Dec 2009 21:42:20 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Wireless list <linux-wireless@vger.kernel.org>,
	rt2x00 users list <users@rt2x00.serialmonkey.com>
References: <1262169394-11647-1-git-send-email-gwingerde@gmail.com> <1262169394-11647-5-git-send-email-gwingerde@gmail.com> <1262169394-11647-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262169394-11647-6-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912302142.20380.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 December 2009, Gertjan van Wingerde wrote:
> rt2800_blink_set uses an illegal value to set the LED_CFG_G_LED_MODE
> field of the LED_CFG register. This field is only 2 bits large, so
> should be initialized with value that fits. Use default value from
> the vendor driver.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
