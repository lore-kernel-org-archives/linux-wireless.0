Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24963 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbZLXFqK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 00:46:10 -0500
Subject: Re: iwlwifi
From: Zhu Yi <yi.zhu@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20091223.210818.02262058.davem@davemloft.net>
References: <20091223.210818.02262058.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 13:46:07 +0800
Message-ID: <1261633567.6037.1.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-12-24 at 13:08 +0800, David Miller wrote:
> 
> Someone please expediently fix whatever it is that makes the iwlwifi
> drivers rebuild every single time I type make.
> 
> It's a real intense pain when I have an 'allmodconfig' tree for build
> validations, I pull some unrelated changed into the tree, and I see
> iwlwifi rebuild no matter what.
> 
> This is not sane behavior. 

I'm trying allmodconfig on wireless-testing now. It takes some time to
finish make. But a simple running "make M=drivers/net/wireless/" twice
doesn't show this issue.

Thanks,
-yi

