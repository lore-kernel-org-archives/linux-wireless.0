Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52243 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091Ab0HDTPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 15:15:03 -0400
Date: Wed, 4 Aug 2010 15:03:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/8] iwlwifi update for 2.6.36
Message-ID: <20100804190320.GQ17666@tuxdriver.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 31, 2010 at 08:34:04AM -0700, Wey-Yi Guy wrote:
> We move "Thermal throttling" related functions out of power management
> into it own file.
> We also reduce the warning level for "BA scd_flow not match" to
> avoid flood the syslog when condition detected.
> We also track IBSS manager status with uCode beacon notification.
> 
> Johannes Berg (2):

>   iwlwifi: fix compile warning
> 
> Wey-Yi Guy (6):

>   iwlwifi: BA scd_flow not match condition detected
>   iwlagn: fix typo in ucode_bt_stats_read debugfs

I'm applying these directly as fixes intended for 2.6.36.  I will
apply the others to wireless-next-2.6 after the merge window closes
for 2.6.36.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
