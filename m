Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59012 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab1LVK24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 05:28:56 -0500
Subject: Re: [PATCH] NFC: Export a new attribute nfcid1 in target info
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: ilanelias78@gmail.com
Cc: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
In-Reply-To: <1324547514-3237-1-git-send-email-ilane@ti.com>
References: <1324547514-3237-1-git-send-email-ilane@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Dec 2011 11:34:13 +0100
Message-ID: <1324550053.5354.7.camel@sortiz-mobl> (sfid-20111222_112900_028317_F9F69803)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Thu, 2011-12-22 at 11:51 +0200, ilanelias78@gmail.com wrote:
> From: Ilan Elias <ilane@ti.com>
> 
> The nfcid1 is the NFC-A identifier.
> It is exported as an attribute of the target info
> (returned as a response to NFC_CMD_GET_TARGET).
> 
> Signed-off-by: Ilan Elias <ilane@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.


