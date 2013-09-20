Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26094 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3ITPau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 11:30:50 -0400
Date: Fri, 20 Sep 2013 17:30:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	Ilan Elias <ilane@ti.com>
Subject: Re: [PATCH 1/2] NFC: Remove redundant dev_set_drvdata
Message-ID: <20130920153045.GD26066@zurbaran> (sfid-20130920_173053_766611_E6994789)
References: <1379667641-31149-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379667641-31149-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sachin,

On Fri, Sep 20, 2013 at 02:30:40PM +0530, Sachin Kamat wrote:
> Driver core sets driver data to NULL upon failure or remove.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Ilan Elias <ilane@ti.com>
> ---
> Series compile tested.
> ---
>  drivers/nfc/nfcwilink.c |    2 --
>  1 file changed, 2 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
