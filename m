Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:33599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751579AbYKKUOL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 15:14:11 -0500
Date: Tue, 11 Nov 2008 12:04:57 -0800
From: Greg KH <greg@kroah.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
	"rjw@sisk.pl" <rjw@sisk.pl>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: fix suspend to RAM in iwlwifi
Message-ID: <20081111200457.GB1784@kroah.com> (sfid-20081111_211417_005912_7B6AD3DD)
References: <1226191867-22324-1-git-send-email-tomas.winkler@intel.com> <1226191867-22324-2-git-send-email-tomas.winkler@intel.com> <1226191867-22324-3-git-send-email-tomas.winkler@intel.com> <1226280376.2604.280.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1226280376.2604.280.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 10, 2008 at 09:26:16AM +0800, Zhu Yi wrote:
> On Sun, 2008-11-09 at 08:51 +0800, Tomas Winkler wrote:
> > This patch fixes suspend to RAM after by moving
> > notify_mac out of iwlwifi mutex
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=11845
> 
> Greg, please also merge the iwl3945 counterpart for this problem.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d54bc4e3fc5c56600a13c9ebc0a7e1077ac05d59

I've added this now.

thanks,

greg k-h
