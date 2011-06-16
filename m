Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab1FPINh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 04:13:37 -0400
Date: Thu, 16 Jun 2011 10:14:27 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"open list:INTEL WIRELESS 39..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] iwlegacy: fix up brokenness caused by cleanup
Message-ID: <20110616081426.GA2178@redhat.com> (sfid-20110616_101342_875950_C7505852)
References: <20110615131009.GD23739@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110615131009.GD23739@shale.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 15, 2011 at 04:10:10PM +0300, Dan Carpenter wrote:
> Patch 7f1f9742514 "iwlegacy: refactor iwl4965_mac_channel_switch"
> reversed a test and also it changed a spin_lock_irq() to
> spin_lock().  I assume the spin_lock change was a mistake because
> the unlock was left as spin_unlock_irq().

Thank you Dan!

Stanislaw
