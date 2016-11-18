Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:32844 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753163AbcKRUTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 15:19:36 -0500
Date: Fri, 18 Nov 2016 12:19:33 -0800
From: Tony Lindgren <tony@atomide.com>
To: Matt Ranostay <matt@ranostay.consulting>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH] mmc: pwrseq: add support for Marvell SD8787 chip
Message-ID: <20161118201932.GY4082@atomide.com> (sfid-20161118_211941_118291_46A6A8A9)
References: <1479434109-8745-1-git-send-email-matt@ranostay.consulting>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479434109-8745-1-git-send-email-matt@ranostay.consulting>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Matt Ranostay <matt@ranostay.consulting> [161117 17:55]:
> Allow power sequencing for the Marvell SD8787 Wifi/BT chip.
> This can be abstracted to other chipsets if needed in the future.

Good to see this happening:

Acked-by: Tony Lindgren <tony@atomide.com>
