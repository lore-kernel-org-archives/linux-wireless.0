Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:44702 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3JBF2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 01:28:50 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v6 3/4] Bluetooth: btmrvl: add setup handler
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1380655155-10007-4-git-send-email-bzhao@marvell.com>
Date: Wed, 2 Oct 2013 07:28:29 +0200
Cc: <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <CCFF3D0B-57CE-40C7-A836-E0631822FF23@holtmann.org> (sfid-20131002_072854_909700_98027A4B)
References: <1380655155-10007-1-git-send-email-bzhao@marvell.com> <1380655155-10007-4-git-send-email-bzhao@marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

> Move initialization code to hdev's setup handler.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
> v6: remove setup_done variable (Marcel Holtmann)
>    This change requires a fix in hci_core for hci_setup.
> v5: make use of hdev's setup handler (Marcel Holtmann)
> 
> drivers/bluetooth/btmrvl_main.c | 18 ++++++++++++++++--
> drivers/bluetooth/btmrvl_sdio.c |  6 ------
> 2 files changed, 16 insertions(+), 8 deletions(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

