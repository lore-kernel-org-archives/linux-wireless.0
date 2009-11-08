Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:48837 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZKHMlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 07:41:47 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so2346744ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 04:41:52 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Move interface type assignments to generic code.
Date: Sun, 8 Nov 2009 13:39:26 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1257679814-25233-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257679814-25233-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200911081339.26102.bzolnier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 12:30:14 Gertjan van Wingerde wrote:
> Make sure all drivers can benefit of the assignment of the interface type of an adapter, instead of
> keeping it for rt2800 only.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Thanks for fixing it.
