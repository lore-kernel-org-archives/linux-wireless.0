Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbYLVD4j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:56:39 -0500
Subject: Re: [PATCH 00/43] iwl3945 merges into iwlagn (Dec 19)
From: Zhu Yi <yi.zhu@intel.com>
To: drago01 <drago01@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <f6ca9fed0812191132h2f76ce40id20c52bdb6e0681c@mail.gmail.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
	 <f6ca9fed0812191132h2f76ce40id20c52bdb6e0681c@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Dec 2008 11:55:35 +0800
Message-Id: <1229918135.24353.177.camel@debian.sh.intel.com> (sfid-20081222_045643_444742_F068F272)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-12-20 at 03:32 +0800, drago01 wrote:
> 
> Well it doesn't really matter but wouldn't it make sense to rename the
> driver back to iwlwifi ? (as 3945 does not support n mode)

Well, an AGN driver (iwlagn) doesn't mean it cannot support AG only
(3945) device ;-) But, iwlwifi should also be fine. Tomas and Reinette,
what do you think? Anyway, we can decide until the port is done in .30
time frame.

Thanks,
-yi

