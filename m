Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42831 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbXIDPzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 11:55:18 -0400
Date: Tue, 4 Sep 2007 16:55:13 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Message-ID: <20070904155513.GA9702@infradead.org>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188875058.13078.428.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 04, 2007 at 11:04:17AM +0800, Zhu Yi wrote:
> In this version, we replace the "comiple iwl-base.c twice for two
> drivers" scheme with separating the two drivers into two code base. In
> the future, we will abstract a common layer for all the iwl based
> drivers and make it a separate module for better maintenance.

Nice.  But please also get rid of the Makefile hacks added for this now
that they're not required anymore.

