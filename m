Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:46296 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYKGSOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 13:14:55 -0500
Received: by yx-out-2324.google.com with SMTP id 8so546705yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2008 10:14:53 -0800 (PST)
Subject: Re: [PATCH 09/13] iwl3945 : Fix Sparse Warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
References: <> <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 10:07:56 -0800
Message-Id: <1226081276.11596.24.camel@brick> (sfid-20081107_191459_241491_A2323CCF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-11-07 at 09:58 -0800, Reinette Chatre wrote:
> From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>
> 
> Patch fixes sparse warnings. No need to convert u8 variable
> to 32.
> 
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

It's customary to put the actual sparse warnings being fixed in the
commit message.  In this case I assume it was this:

drivers/net/wireless/iwlwifi/iwl3945-base.c:4838:18: warning: invalid assignment: |=
drivers/net/wireless/iwlwifi/iwl3945-base.c:4838:18:    left side has type unsigned char
drivers/net/wireless/iwlwifi/iwl3945-base.c:4838:18:    right side has type restricted __le32

Anyways, looks fine.

Cheers,

Harvey

