Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46926 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1LJQKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 11:10:31 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Hsu\, Kenny" <kenny.hsu@intel.com>
Subject: Re: [PATCH 01/15] iwlwifi: add uCode version information support by testmode
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
	<1323390382-1678-2-git-send-email-wey-yi.w.guy@intel.com>
Date: Sat, 10 Dec 2011 18:10:25 +0200
In-Reply-To: <1323390382-1678-2-git-send-email-wey-yi.w.guy@intel.com> (Wey-Yi
	Guy's message of "Thu, 8 Dec 2011 16:26:08 -0800")
Message-ID: <87vcpoe7bi.fsf@purkki.adurom.net> (sfid-20111210_171035_537950_C75FF918)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wey-Yi Guy <wey-yi.w.guy@intel.com> writes:

> From: Hsu, Kenny <kenny.hsu@intel.com>
>
> Create new tm command to report uCode version to userspace
> - IWL_TM_CMD_APP2DEV_GET_FW_VERSION

Why not use wiphy.fw_version which is specifally meant for this purpose?

-- 
Kalle Valo
