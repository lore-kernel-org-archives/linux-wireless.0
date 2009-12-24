Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53741
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055AbZLXGav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 01:30:51 -0500
Date: Wed, 23 Dec 2009 22:30:53 -0800 (PST)
Message-Id: <20091223.223053.52203554.davem@davemloft.net>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi
From: David Miller <davem@davemloft.net>
In-Reply-To: <1261635896.6037.26.camel@debian>
References: <1261633567.6037.1.camel@debian>
	<20091223.215221.191412308.davem@davemloft.net>
	<1261635896.6037.26.camel@debian>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Thu, 24 Dec 2009 14:24:56 +0800

> Thanks. It was first introduced by below commit. And was later changed
> to use generated/utsrelease.h. I'm wondering if we should really use
> linux/utsrelease.h (or linux/version.h) or remove the kernel version
> totally from the driver version (driver compile tag can be remained).
> Any suggestions?

Remove the dependency, every time you type make the build number
increases and this will force your driver to rebuild.
