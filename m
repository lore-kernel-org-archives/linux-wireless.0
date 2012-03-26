Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40763 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab2CZBun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2012 21:50:43 -0400
Subject: Re: [PATCH] iwlwifi: fix unused variable warning
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>
In-Reply-To: <4F6EBE8C.6000302@hartkopp.net>
References: <1318506157-10329-1-git-send-email-mkl@pengutronix.de>
	 <4F6EBE8C.6000302@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Mar 2012 18:49:28 -0700
Message-ID: <1332726568.27767.13.camel@wwguy-huron> (sfid-20120326_035046_582029_C00DF725)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-03-25 at 08:43 +0200, Oliver Hartkopp wrote:
> In the case of disabled CONFIG_IWLWIFI_DEBUGFS option the compiler complains
> about the unused variable 'img'. Fix this by moving the 'img' definition.
> 
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>





