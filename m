Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1LJRvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 12:51:23 -0500
Subject: Re: [PATCH 07/15] iwlwifi: add device ID information support by
 testmode
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Hsu, Kenny" <kenny.hsu@intel.com>
In-Reply-To: <1323390382-1678-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022535_454507_1587E816)
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1323390382-1678-8-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20111209_022535_454507_1587E816)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Dec 2011 18:51:19 +0100
Message-ID: <1323539479.3344.31.camel@jlt3.sipsolutions.net> (sfid-20111210_185128_574123_C0C3B2A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-08 at 16:26 -0800, Wey-Yi Guy wrote:

> +	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
> +		bus_get_hw_id(bus(priv), buf, sizeof(buf));
> +		ptr = buf;
> +		strsep(&ptr, ":");
> +		sscanf(strsep(&ptr, ":"), "%x", &num);
> +		sscanf(strsep(&ptr, ":"), "%x", &devid);

This is kinda ugly too ... sorry, should've seen it earlier.

johannes

