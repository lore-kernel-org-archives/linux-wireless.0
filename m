Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37756 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989Ab3I3DaY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Sep 2013 23:30:24 -0400
Message-ID: <1380511808.1441.3.camel@deadeye.wl.decadent.org.uk> (sfid-20130930_053040_060454_B076002E)
Subject: Re: [PATCH] cw1200: Add SDD file for the Sagrad SG901-1091/1098
 WLAN modules.
From: Ben Hutchings <ben@decadent.org.uk>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Adam Harriman <adam@sagrad.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 30 Sep 2013 04:30:08 +0100
In-Reply-To: <1378335153-23059-1-git-send-email-pizza@shaftnet.org>
References: <1378335153-23059-1-git-send-email-pizza@shaftnet.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-09-04 at 18:52 -0400, Solomon Peachy wrote:
> Sagrad has granted permission to redistribute this file, which contains
> calibration and initialization tables for for their WLAN modules.
> 
> Please note that the cw1200 driver still requires firmware files, which
> are separately licensed by ST-E.  When (if?) explicit permission is
> obtained to redistribute the firmware, it will be added.
> 
> Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
> Signed-off-by: Adam Harriman <adam@sagrad.com>
> ---
>  WHENCE                   |  22 ++++++++++++++++++++++
>  sdd_sagrad_1091_1098.bin | Bin 0 -> 816 bytes
>  2 files changed, 22 insertions(+)
>  create mode 100644 sdd_sagrad_1091_1098.bin
[...]

Applied, thanks.

Ben.

-- 
Ben Hutchings
Life is like a sewer:
what you get out of it depends on what you put into it.
