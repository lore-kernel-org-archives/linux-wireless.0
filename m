Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51835 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaJHIxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 04:53:33 -0400
Message-ID: <1412758401.1811.0.camel@jlt4.sipsolutions.net> (sfid-20141008_105338_260141_F0719636)
Subject: Re: [PATCH 1/5] net: rfkill: gpio: Configurable GPIO idx
From: Johannes Berg <johannes@sipsolutions.net>
To: Loic Poulain <loic.poulain@intel.com>
Cc: heikki.krogerus@linux.intel.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Date: Wed, 08 Oct 2014 10:53:21 +0200
In-Reply-To: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
References: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-08 at 10:34 +0200, Loic Poulain wrote:

> +	{ "BCM2E1A", (kernel_ulong_t)&acpi_default_bluetooth },

Shouldn't that be uintptr_t?

johannes

