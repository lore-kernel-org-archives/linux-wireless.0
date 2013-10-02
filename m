Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:44729 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3JBFbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 01:31:23 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v6 1/4] Bluetooth: btmrvl: add btmrvl_send_sync_cmd() function
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1380655155-10007-2-git-send-email-bzhao@marvell.com>
Date: Wed, 2 Oct 2013 07:30:56 +0200
Cc: <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <DE4D5E1A-86DB-410F-A9B6-618616D2BAD9@holtmann.org> (sfid-20131002_073126_882814_85FFFF06)
References: <1380655155-10007-1-git-send-email-bzhao@marvell.com> <1380655155-10007-2-git-send-email-bzhao@marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

> Command preparation code is used multiple times. This patch
> separate out this common code and create btmrvl_send_sync_cmd()
> function.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
> v6: separate out common code
> 
> drivers/bluetooth/btmrvl_main.c | 129 +++++++++++++---------------------------
> 1 file changed, 41 insertions(+), 88 deletions(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

