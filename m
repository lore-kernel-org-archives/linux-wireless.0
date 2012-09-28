Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:54114 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2I1IuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 04:50:14 -0400
Message-ID: <1348822189.15949.5.camel@cumari.coelho.fi> (sfid-20120928_105018_497468_21D39B63)
Subject: Re: [PATCH 3.6-rc3 v2] wlcore: Declare MODULE_FIRMWARE usage
From: Luciano Coelho <luca@coelho.fi>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Fri, 28 Sep 2012 11:49:49 +0300
In-Reply-To: <1346267373-19591-1-git-send-email-tim.gardner@canonical.com>
References: <1346266668.3935.23.camel@cumari.coelho.fi>
	 <1346267373-19591-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-29 at 13:09 -0600, Tim Gardner wrote:
> Declare any firmware that might be used by this driver.
> If all drivers declare their firmware usage, then a sufficiently
> complete list of firmware files can then be used to pare down
> the external linux-firmware package to just the files in actual use.
> 
> Cc: Luciano Coelho <coelho@ti.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---

Applied, thank you!

--
Luca.

