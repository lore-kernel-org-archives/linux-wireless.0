Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57245 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab2AEPwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 10:52:14 -0500
Subject: Re: [PATCH 2/2] NFC: Handle error during NCI data exchange
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: ilanelias78@gmail.com
Cc: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
In-Reply-To: <1324393061-32173-3-git-send-email-ilane@ti.com>
References: <1324393061-32173-1-git-send-email-ilane@ti.com>
	 <1324393061-32173-3-git-send-email-ilane@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Jan 2012 16:57:59 +0100
Message-ID: <1325779079.5354.15.camel@sortiz-mobl> (sfid-20120105_165221_811802_13216B8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Tue, 2011-12-20 at 16:57 +0200, ilanelias78@gmail.com wrote:
> From: Ilan Elias <ilane@ti.com>
> 
> Add support for NCI Interface Error Notification.
> When this notification is received and we're during a
> data exchange transaction, indicate an error to the NFC
> core layer via the data exchange callback.
> 
> Signed-off-by: Ilan Elias <ilane@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.


