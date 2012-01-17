Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34336 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2AQLMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 06:12:05 -0500
Subject: Re: [PATCH] NFC: Increase NCI deactivate timeout
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: ilanelias78@gmail.com
Cc: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
In-Reply-To: <1326022982-30205-1-git-send-email-ilane@ti.com>
References: <1326022982-30205-1-git-send-email-ilane@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 12:18:11 +0100
Message-ID: <1326799091.22824.25.camel@sortiz-mobl> (sfid-20120117_121208_162509_58E711A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Sun, 2012-01-08 at 13:43 +0200, ilanelias78@gmail.com wrote:
> From: Ilan Elias <ilane@ti.com>
> 
> Increase NCI deactivate timeout from 5 sec to 30 sec.
> NCI deactivate procedure might take a long time,
> depending on the local and remote parameters.
> 
> Signed-off-by: Ilan Elias <ilane@ti.com>
Thanks for the explanations:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.


