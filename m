Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbXJQHlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 03:41:44 -0400
Subject: Re: [2.6 patch] iwl4965-base.c: fix off-by-one errors
From: Zhu Yi <yi.zhu@intel.com>
To: Adrian Bunk <bunk@kernel.org>,
	"John W.Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20071014175115.GL4211@stusta.de>
References: <20071014175115.GL4211@stusta.de>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 15:33:52 +0800
Message-Id: <1192606433.2992.20.camel@debian.sh.intel.com> (sfid-20071017_084148_663995_A973E87C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sun, 2007-10-14 at 19:51 +0200, Adrian Bunk wrote:
> This patch fixes two off-by-one errors resulting in array overflows 
> spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

ACK.

John, please apply.

Thanks,
-yi
