Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab2FNSij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 14:38:39 -0400
Message-ID: <1339699110.9786.9.camel@jlt3.sipsolutions.net> (sfid-20120614_203846_395420_1F3EE948)
Subject: Re: [patch -next] iwlwifi: unlock on error path
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 14 Jun 2012 20:38:30 +0200
In-Reply-To: <20120614183526.GD6383@elgon.mountain> (sfid-20120614_203557_447921_E8796EB4)
References: <20120614183526.GD6383@elgon.mountain>
	 (sfid-20120614_203557_447921_E8796EB4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-14 at 21:35 +0300, Dan Carpenter wrote:
> We introduced a lock here in ff1ffb850b ("iwlwifi: fix dynamic
> loading").  But we missed an error path which needs an unlock.

Thanks Dan. John, this is the other merge issue I was talking about :-)

johannes

