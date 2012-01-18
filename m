Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2ARMco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 07:32:44 -0500
Subject: Re: [PATCH v3 2/3] NFC: Download TI NFC init script
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: ilanelias78@gmail.com
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
In-Reply-To: <1326802293-11539-3-git-send-email-ilane@ti.com>
References: <1326802293-11539-1-git-send-email-ilane@ti.com>
	 <1326802293-11539-3-git-send-email-ilane@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jan 2012 13:38:54 +0100
Message-ID: <1326890334.22824.28.camel@sortiz-mobl> (sfid-20120118_133247_229796_35AC55AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Tue, 2012-01-17 at 14:11 +0200, ilanelias78@gmail.com wrote:
> From: Ilan Elias <ilane@ti.com>
> 
> Download TI NFC init script during nfcwilink open operation,
> after the NFC channel is registered with TI shared transport.
> TI NFC init script is written in BTS format.
> First, read the chip version via a special vendor specific command.
> Second, we request the relevant BTS file from the user space, and
> then send the BTS commands to the chip.
> 
> Signed-off-by: Ilan Elias <ilane@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.


