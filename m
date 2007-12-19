Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbXLSH2k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 02:28:40 -0500
Subject: Re: [PATCH] ipw2200: prevent alloc of unspecified size on stack
From: Zhu Yi <yi.zhu@intel.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	viro@zeniv.linux.org.uk
In-Reply-To: <20071219063526.GH8181@ftp.linux.org.uk>
References: <1198044062-25201-1-git-send-email-reinette.chatre@intel.com>
	 <20071219063526.GH8181@ftp.linux.org.uk>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 15:16:13 +0800
Message-Id: <1198048573.2857.330.camel@debian.sh.intel.com> (sfid-20071219_072842_228404_AF30FADA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-12-19 at 06:35 +0000, Al Viro wrote:
> to be provably safe against wraparounds, if you really want to limit
> that to PAGE_SIZE...

This is a sysfs read. We can only print PAGE_SIZE at most anyway.

Thanks,
-yi

