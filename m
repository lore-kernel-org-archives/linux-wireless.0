Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41806 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2ARMdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 07:33:19 -0500
Subject: Re: [PATCH v3 3/3] NFC: Free sk_buff if nfcwilink_send fails
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: ilanelias78@gmail.com
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
In-Reply-To: <1326802293-11539-4-git-send-email-ilane@ti.com>
References: <1326802293-11539-1-git-send-email-ilane@ti.com>
	 <1326802293-11539-4-git-send-email-ilane@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jan 2012 13:39:27 +0100
Message-ID: <1326890367.22824.29.camel@sortiz-mobl> (sfid-20120118_133322_161243_9BCA5A63)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Tue, 2012-01-17 at 14:11 +0200, ilanelias78@gmail.com wrote:
> From: Ilan Elias <ilane@ti.com>
> 
> Free sk_buff if nfcwilink_send fails.
> 
> Signed-off-by: Ilan Elias <ilane@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.


