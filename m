Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54067 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbZL3UmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 15:42:04 -0500
Received: by ewy19 with SMTP id 19so4058353ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2009 12:42:00 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 3/6] rt2x00: RF3052 is a valid RF chipset for USB devices as well.
Date: Wed, 30 Dec 2009 21:41:58 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Wireless list <linux-wireless@vger.kernel.org>,
	rt2x00 users list <users@rt2x00.serialmonkey.com>
References: <1262169394-11647-1-git-send-email-gwingerde@gmail.com> <1262169394-11647-3-git-send-email-gwingerde@gmail.com> <1262169394-11647-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262169394-11647-4-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912302141.58667.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 December 2009, Gertjan van Wingerde wrote:
> The RF3052 chipset is now also being integrated onto USB devices, so
> allow the RF chipset and don't treat it as PCI/SOC only.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
