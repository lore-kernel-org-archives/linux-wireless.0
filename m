Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41377 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYKHEvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 23:51:46 -0500
Message-ID: <491528F5.3070408@holtmann.org> (sfid-20081108_055208_018859_7EF8DA39)
Date: Sat, 08 Nov 2008 06:51:49 +0100
From: Marcel Holtmann <marcel@holtmann.org>
MIME-Version: 1.0
To: Reinette Chatre <reinette.chatre@intel.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Halperin, Daniel C" <daniel.c.halperin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 05/13] iwlwifi: update iwl-commands.h for 3 stream support
References: <> <1226080726-24860-1-git-send-email-reinette.chatre@intel.com> <1226080726-24860-2-git-send-email-reinette.chatre@intel.com> <1226080726-24860-3-git-send-email-reinette.chatre@intel.com> <1226080726-24860-4-git-send-email-reinette.chatre@intel.com> <1226080726-24860-5-git-send-email-reinette.chatre@intel.com> <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

> From: Halperin, Daniel C <daniel.c.halperin@intel.com>
> 
> This patch updates comments and constants to support 1, 2, or 3 spatial streams
> in rate_n_flags .
> 
> Signed-off-by: Daniel Halperin <daniel.c.halperin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

so this has been mentioned before, but lets do it again. Since you are 
the person who sends the patches upstream, your Signed-off-by line has 
to be the last one. If you ever touched the patch, looked at it or not 
makes no difference here. The line is just there to track the steps it 
made into mainline.

The original or main author is of course the first Signed-off-by line.

So with patch I assume that Daniel send the patch to Tomas and then 
Tomas queued them up and send a bunch of patches to you. If Tomas just 
reviewed the patch, I like really to see the proper Acked-by lines in 
between in the future.

Also there is no problem if we start adding Tested-by from the people 
that actually run validation tests of the patches.

Regards

Marcel

