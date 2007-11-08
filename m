Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:34858 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761234AbXKHSXk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2007 13:23:40 -0500
Date: Thu, 8 Nov 2007 19:22:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH 3/5] iwlwifi: cleanup namespace
Message-ID: <20071108182254.GA32063@lst.de> (sfid-20071108_182346_901915_1F9DC211)
References: <11944155883607-git-send-email-reinette.chatre@intel.com> <1194415589137-git-send-email-reinette.chatre@intel.com> <11944155913421-git-send-email-reinette.chatre@intel.com> <11944155923015-git-send-email-reinette.chatre@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <11944155923015-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 06, 2007 at 10:06:26PM -0800, Reinette Chatre wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Prefix all symbols with iwl3945_ or iwl4965_ and thus allow building
> the driver into the kernel. Also remove all the useless default statements
> in Kconfig while we're at it.

Any chance we can get this whole patch series into 2.6.24?  It's just
a blind cleanup of the symbols and having two new drivers that can't
be built into the kernel or loaded into the kernel is rather
embarassing.

