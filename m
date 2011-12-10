Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41484 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1LJQPR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 11:15:17 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Hsu\, Kenny" <kenny.hsu@intel.com>
Subject: Re: [PATCH 07/15] iwlwifi: add device ID information support by testmode
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
	<1323390382-1678-8-git-send-email-wey-yi.w.guy@intel.com>
Date: Sat, 10 Dec 2011 18:15:16 +0200
In-Reply-To: <1323390382-1678-8-git-send-email-wey-yi.w.guy@intel.com> (Wey-Yi
	Guy's message of "Thu, 8 Dec 2011 16:26:14 -0800")
Message-ID: <87r50ce73f.fsf@purkki.adurom.net> (sfid-20111210_171522_108391_06DC661F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wey-Yi Guy <wey-yi.w.guy@intel.com> writes:

> Create new tm command to report devce ID information to userspace
> - IWL_TM_CMD_APP2DEV_GET_DEVICE_ID

And for this we have wiphy.hw_version which is exported via the ethtool
interface.

-- 
Kalle Valo
