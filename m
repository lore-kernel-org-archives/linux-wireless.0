Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:46429 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0ALXvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 18:51:54 -0500
Received: by pzk1 with SMTP id 1so6670630pzk.33
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 15:51:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263336387-30707-1-git-send-email-hauke@hauke-m.de>
References: <1263336387-30707-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 12 Jan 2010 15:51:32 -0800
Message-ID: <43e72e891001121551u1d5ccf18h76ff70f3eda5d238@mail.gmail.com>
Subject: Re: [PATCH 1/2] compat-wireless: Backport netdev_ops select_queue
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 12, 2010 at 2:46 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> eth_mac_addr was added to dataif, but it should be monitor
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Both applied, thanks.

  Luis
