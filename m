Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1DKOi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 10:38:59 -0400
Subject: Re: [PATCH] CHROMIUM: config: bluetooth: rfkill driver
From: Johannes Berg <johannes@sipsolutions.net>
To: aidapalapati@nvidia.com
Cc: olofj@chromium.org, linville@tuxdriver.com, uraval@nvidia.com,
	linux-wireless@vger.kernel.org, aritger@nvidia.com,
	krakesh@nvidia.com
In-Reply-To: <1302532426-12846-1-git-send-email-aidapalapati@nvidia.com>
References: <1302532426-12846-1-git-send-email-aidapalapati@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 16:38:54 +0200
Message-ID: <1302532734.6487.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-11 at 20:03 +0530, aidapalapati@nvidia.com wrote:
> From: Anantha Idapalapati <aidapalapati@nvidia.com>
> 
> Initial version of new "rfkill" driver to control BT radio.
> A new kernel config variable CONFIG_BT_RFKILL is defined and
> need to be used to include this driver in the kernel.

That seems a little too generic, given the fact that this needs some
specific bcm4329 chip? Or then again, does it really? It should just be
called BT GPIO RFkill, no?

johannes

