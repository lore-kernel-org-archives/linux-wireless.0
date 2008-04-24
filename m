Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34367
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752916AbYDXCnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 22:43:18 -0400
Date: Wed, 23 Apr 2008 19:43:21 -0700 (PDT)
Message-Id: <20080423.194321.112971699.davem@davemloft.net> (sfid-20080424_044354_064842_CCEFB468)
To: yi.zhu@intel.com
Cc: torvalds@linux-foundation.org, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com
Subject: Re: [PATCH] iwlwifi: Fix built-in compilation of iwlcore (part 2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209004307.17816.33.camel@debian.sh.intel.com>
References: <1208947121-22640-1-git-send-email-tomas.winkler@intel.com>
	<1209004307.17816.33.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Thu, 24 Apr 2008 10:31:47 +0800

> On Wed, 2008-04-23 at 13:38 +0300, Tomas Winkler wrote:
> > This patch fixes problem in Makefile that prevented
> > built-in compilation of iwlcore
> 
> Here is the second part. Without this,
> drivers/net/wireless/iwlwifi/build-in.o will not be linked into vmlinux.
> 
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Did you guys even test the original patch sent last night at all?

Sigh... I'll add this, thanks.
