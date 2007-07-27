Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2428 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbXG0JcX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:32:23 -0400
Subject: Re: [PATCH 00/17] iwlwifi driver updated to version 0.1.5
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <11855284012123-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 17:30:19 +0800
Message-Id: <1185528619.3079.95.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-07-27 at 17:26 +0800, Zhu Yi wrote:
> 
> Here are a series of patches to update iwlwifi driver to 0.1.5. 

Forgot to mention, since 0.1.5 we add the multiple firmware images
support (ucode image filename is renamed). So please use the new uCodes
we just released:

iwlwifi-4965-ucode-4.44.1.18
iwlwifi-3945-ucode-2.14.1.5

http://intellinuxwireless.org/index.php?n=Downloads

Thanks,
-yi
