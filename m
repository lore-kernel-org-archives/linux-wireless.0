Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28219 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1LJRX5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 12:23:57 -0500
Subject: Re: [PATCH 01/15] iwlwifi: add uCode version information support
 by testmode
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hsu, Kenny" <kenny.hsu@intel.com>
In-Reply-To: <87vcpoe7bi.fsf@purkki.adurom.net>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1323390382-1678-2-git-send-email-wey-yi.w.guy@intel.com>
	 <87vcpoe7bi.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Dec 2011 08:25:07 -0800
Message-ID: <1323534307.13074.192.camel@wwguy-huron> (sfid-20111210_182402_822647_8996E522)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-12-10 at 08:10 -0800, Kalle Valo wrote:
> Wey-Yi Guy <wey-yi.w.guy@intel.com> writes:
> 
> > From: Hsu, Kenny <kenny.hsu@intel.com>
> >
> > Create new tm command to report uCode version to userspace
> > - IWL_TM_CMD_APP2DEV_GET_FW_VERSION
> 
> Why not use wiphy.fw_version which is specifally meant for this purpose?
> 

fw_version is being formatted to string. we need u32

Wey


