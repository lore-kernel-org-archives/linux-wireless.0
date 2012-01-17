Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60713 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2AQLNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 06:13:46 -0500
Subject: Re: [PATCH v2] NFC: Export new attributes sensb_res and sensf_res
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: ilanelias78@gmail.com
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
In-Reply-To: <1326791203-10990-1-git-send-email-ilane@ti.com>
References: <1326791203-10990-1-git-send-email-ilane@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 12:19:56 +0100
Message-ID: <1326799196.22824.26.camel@sortiz-mobl> (sfid-20120117_121350_164733_B5E14A7E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Tue, 2012-01-17 at 11:06 +0200, ilanelias78@gmail.com wrote:
> From: Ilan Elias <ilane@ti.com>
> 
> Export new attributes sensb_res for tech B and sensf_res
> for tech F in the target info (returned as a response to
> NFC_CMD_GET_TARGET).
> The max size of the attributes nfcid1, sensb_res and sensf_res
> is exported to user space though include/linux/nfc.
> 
> Signed-off-by: Ilan Elias <ilane@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.


