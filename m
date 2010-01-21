Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:51605 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab0AUX0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 18:26:44 -0500
Received: by pxi12 with SMTP id 12so417604pxi.33
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 15:26:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264109388-19746-1-git-send-email-hauke@hauke-m.de>
References: <1264109388-19746-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 21 Jan 2010 15:26:24 -0800
Message-ID: <43e72e891001211526v52a2a540h45e10d2b0761facb@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: fix bluetooth capi build
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2010 at 1:29 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This backports patch 9a58a80a701bdb2d220cdab4914218df5b48d781
> "proc_fops: convert drivers/isdn/ to seq_file" from linux-next.
>
> compile tested only

Good enough for me, thanks, applied.

  Luis
