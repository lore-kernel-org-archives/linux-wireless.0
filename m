Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab2APR5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 12:57:43 -0500
Subject: Re: [PATCH] NFC: Complete NCI deactivate in deactivate_ntf
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: ilanelias78@gmail.com
Cc: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
In-Reply-To: <1326014513-29958-1-git-send-email-ilane@ti.com>
References: <1326014513-29958-1-git-send-email-ilane@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 19:03:52 +0100
Message-ID: <1326737032.22824.10.camel@sortiz-mobl> (sfid-20120116_185746_453484_FAB5DBE2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-01-08 at 11:21 +0200, ilanelias78@gmail.com wrote:
> From: Ilan Elias <ilane@ti.com>
> 
> If a target was active, complete the NCI deactivate request
> only in deactivate_ntf. Otherwise, complete it at deactivate_rsp.
> Deactivate_ntf represents the actual disconnection event (sent from
> the NCI controller).
> 
> Signed-off-by: Ilan Elias <ilane@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.


