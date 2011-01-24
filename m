Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54100 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1AXUS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 15:18:26 -0500
Subject: Re: [PATCH] wl12xx: add missing MODULE_FIRMWARE statment for
 AP-mode FW
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295255760-23759-1-git-send-email-arik@wizery.com>
References: <1295255760-23759-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 22:18:35 +0200
Message-ID: <1295900315.2063.3.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 10:16 +0100, Arik Nemtsov wrote:
> In wl12xx cards AP-mode requires a separate FW file. Add this file to
> the module info.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

