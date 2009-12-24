Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55066
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbZLXFwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 00:52:21 -0500
Date: Wed, 23 Dec 2009 21:52:21 -0800 (PST)
Message-Id: <20091223.215221.191412308.davem@davemloft.net>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi
From: David Miller <davem@davemloft.net>
In-Reply-To: <1261633567.6037.1.camel@debian>
References: <20091223.210818.02262058.davem@davemloft.net>
	<1261633567.6037.1.camel@debian>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Thu, 24 Dec 2009 13:46:07 +0800

> I'm trying allmodconfig on wireless-testing now. It takes some time to
> finish make. But a simple running "make M=drivers/net/wireless/" twice
> doesn't show this issue.
> 

It's the include of generated/utsrelease.h by iwl-core.h that causes
the rebuild.
