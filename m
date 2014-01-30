Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaA3RhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 12:37:23 -0500
Message-ID: <1391103440.4323.24.camel@jlt4.sipsolutions.net> (sfid-20140130_183726_136108_A68FBBD5)
Subject: Re: [PATCH 3.13.1 3/9] rsi: Packet queueing/dequeueing to device
From: Johannes Berg <johannes@sipsolutions.net>
To: Jahnavi <jahnavi.meher@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 30 Jan 2014 18:37:20 +0100
In-Reply-To: <52EA75B5.5040002@redpinesignals.com> (sfid-20140130_170030_682221_D838173E)
References: <52EA75B5.5040002@redpinesignals.com>
	 (sfid-20140130_170030_682221_D838173E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-30 at 21:24 +0530, Jahnavi wrote:

> +#include "../include/rsi_main.h"
> +#include "../include/rsi_device_ops.h"
> +#include "../include/rsi_hw_intf.h"

That also seems a bit odd.

johannes

