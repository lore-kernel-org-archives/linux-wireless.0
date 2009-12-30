Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54067 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZL3UmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 15:42:16 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so4058353ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2009 12:42:15 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 4/6] rt2x00: Unify rt2800 WPDMA ready waiting functions.
Date: Wed, 30 Dec 2009 21:42:13 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Wireless list <linux-wireless@vger.kernel.org>,
	rt2x00 users list <users@rt2x00.serialmonkey.com>
References: <1262169394-11647-1-git-send-email-gwingerde@gmail.com> <1262169394-11647-4-git-send-email-gwingerde@gmail.com> <1262169394-11647-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262169394-11647-5-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912302142.13734.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 December 2009, Gertjan van Wingerde wrote:
> The rt2800pci_wait_wpdma_ready and rt2800usb_wait_wpdma_ready functions are
> exactly the same, so unify them into rt200lib.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>


