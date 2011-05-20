Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:49506 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935420Ab1ETMDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:03:33 -0400
Subject: Re: [RFC/PATCH 04/13] net: wl12xx: care for optional operations
From: Luciano Coelho <coelho@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <1305321990-22041-5-git-send-email-balbi@ti.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
	 <1305321990-22041-5-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 15:03:26 +0300
Message-ID: <1305893006.12586.1665.camel@cumari> (sfid-20110520_140354_814353_BC9AE5B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-05-14 at 00:26 +0300, Felipe Balbi wrote:
> ->init and ->reset are optional - at least
> sdio.c doesn't implement them - so allow those
> pointers to be NULL.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

