Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbYLIUDp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 15:03:45 -0500
Subject: Re: [PATCH 1/4] iwlwifi: change email contact information
From: reinette chatre <reinette.chatre@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1228852251.19553.125.camel@violet.holtmann.net>
References: <> <1228850941-16677-1-git-send-email-reinette.chatre@intel.com>
	 <1228850941-16677-2-git-send-email-reinette.chatre@intel.com>
	 <1228852251.19553.125.camel@violet.holtmann.net>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 12:04:46 -0800
Message-Id: <1228853086.2339.33.camel@rc-desk> (sfid-20081209_210351_486552_759F19D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-12-09 at 11:50 -0800, Marcel Holtmann wrote:

> just double checking that "ilw" is intentional. It is kinda weird since
> we prefix our driver with "iwl". It might be a little bit confusing.

Yes - "ilw" is intentional (not a typo). 

> 
> Also the MODULE_AUTHOR tag should contain the maintainer information. At
> least that is what the current consensus is. I know that the word author
> is kinda misleading here.

The author currently contains "Intel Corporation". There are a few
people that fulfill the maintainer role so adding a person's name here
will not work.

Will this be acceptable:

MODULE_AUTHOR("Copyright(c) 2003-2008 Intel Corporation <ilw@linux.intel.com>")

Reinette



