Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56080 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751856AbcFFHzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 03:55:11 -0400
Message-ID: <1465199699.1921.18.camel@coelho.fi> (sfid-20160606_095537_326989_F9669884)
From: Luca Coelho <luca@coelho.fi>
To: Guenter Roeck <linux@roeck-us.net>,
	Johannes Berg <johannes.berg@intel.com>
Cc: linuxwifi@intel.com, Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Mon, 06 Jun 2016 10:54:59 +0300
In-Reply-To: <1464989959-2021-1-git-send-email-linux@roeck-us.net>
References: <1464989959-2021-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: Remove unused array 'iwlagn_loose_lookup'
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-06-03 at 14:39 -0700, Guenter Roeck wrote:
> gcc-6 reports the following error if -Werror=unused-const-variable
> is enabled.
> 
> drivers/net/wireless/intel/iwlwifi/dvm/lib.c:210:21: error:
> 	'iwlagn_loose_lookup' defined but not used
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---

Thanks! I'm queuing this via our internal trees (adding "dvm: " to the
subject, to indicate this is related to the dvm module).

--
Cheers,
Luca.
