Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32181 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbbKSGTT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:19:19 -0500
Date: Thu, 19 Nov 2015 09:19:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: remove define COMPLEMENT_BOOT
Message-ID: <20151119061907.GQ18797@mwanda> (sfid-20151119_071922_678800_027FA7F8)
References: <1447898761-6938-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447898761-6938-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 19, 2015 at 11:05:58AM +0900, Glen Lee wrote:
> This patch removes define COMPLEMENT_BOOT in Makefile. The feature was removed
> by the following commit but the define was not removed. So remove completely.
> 
> b46d68825c2d3af70ad18b53dfed6516e393b7fa

Put some human readable text next to the hash.  The standard thing is to
include only the first 12 characters of the hash.  If there are fewer
than 12 characters then we could get collisions but including the whole
hash is excessive.

This patch removes define COMPLEMENT_BOOT in Makefile. The feature was
removed by commit b46d68825c2d ('staging: wilc1000: remove
COMPLEMENT_BOOT') but the define was not removed. So remove completely.

regards,
dan carpenter

