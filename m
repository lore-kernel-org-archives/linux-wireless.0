Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46078 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab0LRUO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 15:14:58 -0500
Received: by iyi12 with SMTP id 12so1220730iyi.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Dec 2010 12:14:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292625768-17318-2-git-send-email-hauke@hauke-m.de>
References: <1292625768-17318-1-git-send-email-hauke@hauke-m.de> <1292625768-17318-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 18 Dec 2010 12:14:37 -0800
Message-ID: <AANLkTikcwifCiFGeCRBuAnupAycgqeEbkH1=HtxGUdrn@mail.gmail.com>
Subject: Re: [PATCH 2/3] compat-wireless: use pci_is_pcie()
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 17, 2010 at 2:42 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Use pci_is_pcie function and do not access the member of the struct directly.

So we can submit this upstream as well?

  Luis
