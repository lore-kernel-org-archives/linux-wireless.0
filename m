Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55044 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbbGQIQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 04:16:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Oren Givon <oren.givon@intel.com>
Subject: Re: [PATCH 07/10] iwlwifi: edit the 3165 series and 8000 series PCI IDs
References: <1436720814.17999.2.camel@intel.com>
	<1436720900-18588-7-git-send-email-emmanuel.grumbach@intel.com>
Date: Fri, 17 Jul 2015 11:15:57 +0300
In-Reply-To: <1436720900-18588-7-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Sun, 12 Jul 2015 20:08:17 +0300")
Message-ID: <87k2tzurlu.fsf@kamboji.qca.qualcomm.com> (sfid-20150717_101610_889593_45E2D463)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> From: Oren Givon <oren.givon@intel.com>
>
> Add new 3165 devices support.
> Add one new 8000 series device support.
> Remove support for 0x0000, 0xC030 and 0xD030 sub-system IDs
> in the 8000 series.

The commit log doesn't mention anything _why_ the three ids are removed.
In the future please document that so that people don't need to guess.

-- 
Kalle Valo
