Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1LJRiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 12:38:19 -0500
Subject: Re: [PATCH 07/15] iwlwifi: add device ID information support by
 testmode
From: wwguy <wey-yi.w.guy@intel.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hsu, Kenny" <kenny.hsu@intel.com>
In-Reply-To: <87r50ce73f.fsf@purkki.adurom.net>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1323390382-1678-8-git-send-email-wey-yi.w.guy@intel.com>
	 <87r50ce73f.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Dec 2011 09:31:37 -0800
Message-ID: <1323538297.1806.13.camel@wwguy-ubuntu> (sfid-20111210_183823_049339_8435DA06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-12-10 at 08:15 -0800, Kalle Valo wrote:
> Wey-Yi Guy <wey-yi.w.guy@intel.com> writes:
> 
> > Create new tm command to report devce ID information to userspace
> > - IWL_TM_CMD_APP2DEV_GET_DEVICE_ID
> 
> And for this we have wiphy.hw_version which is exported via the ethtool
> interface.
> 
good point, I don't think we ever set it up. I will double check and
submit patches if it is not there.

Wey


