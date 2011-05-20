Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:41117 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935666Ab1ETMEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:04:39 -0400
Subject: Re: [RFC/PATCH 05/13] net: wl12xx: remove the nops
From: Luciano Coelho <coelho@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <1305321990-22041-6-git-send-email-balbi@ti.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
	 <1305321990-22041-6-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 15:04:33 +0300
Message-ID: <1305893073.12586.1667.camel@cumari> (sfid-20110520_140456_724559_765F89FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-05-14 at 00:26 +0300, Felipe Balbi wrote:
> Nops aren't needed. When we actually need
> those calls, then we add them with meat
> and barbecue sauce.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---

Applied the parts that are still relevant (some of the calls already
have saucy beef in them ;).

-- 
Cheers,
Luca.

