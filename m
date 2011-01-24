Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1AXL0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 06:26:49 -0500
Subject: Re: [PATCH 1/1] CHROMIUM: config: bluetooth: rfkill driver
From: Johannes Berg <johannes@sipsolutions.net>
To: aidapalapati@nvidia.com
Cc: olofj@chromium.org, linville@tuxdriver.com, uraval@nvidia.com,
	krakesh@nvidia.com, linux-wireless@vger.kernel.org
In-Reply-To: <1295867209-6156-1-git-send-email-aidapalapati@nvidia.com>
References: <1295867209-6156-1-git-send-email-aidapalapati@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 12:27:34 +0100
Message-ID: <1295868454.3639.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-24 at 16:36 +0530, aidapalapati@nvidia.com wrote:

> A new "rfkill" driver is added to control BT radio.
> A new kernel config variable CONFIG_BT_RFKILL needs to
> be configured to include this driver in the kernel.
> 
> Three resources are expected by the driver.
> One Shutdown GPIO, One Reset Gpio and One reference Clock.
> if any/all of the resources can be defined by a platform.

If that's a generic driver, why can it use

> +		tegra_gpio_enable(bt_rfkill->gpio_reset);

tegra_* functions?

johannes

