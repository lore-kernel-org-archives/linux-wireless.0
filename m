Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab2J2K7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 06:59:09 -0400
Date: Mon, 29 Oct 2012 11:59:03 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] NFC: Remove unused details from pn544.h header file
Message-ID: <20121029105903.GF5411@sortiz-mobl> (sfid-20121029_115913_468611_2AF630F0)
References: <1351104312-5144-1-git-send-email-marcel@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1351104312-5144-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Wed, Oct 24, 2012 at 11:45:12AM -0700, Marcel Holtmann wrote:
> The majority of the defines and structures from pn544.h are no
> longer in use. So just remove them.
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> ---
>  include/linux/nfc/pn544.h | 60 -----------------------------------------------
>  1 file changed, 60 deletions(-)
Thanks for the cleanup, I applied this patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
