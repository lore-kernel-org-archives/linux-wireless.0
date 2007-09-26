Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49339
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754268AbXIZCet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 22:34:49 -0400
Date: Tue, 25 Sep 2007 19:34:48 -0700 (PDT)
Message-Id: <20070925.193448.56586274.davem@davemloft.net>
To: yi.zhu@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	chuyee@santarosa.sh.intel.com
Subject: Re: [PATCH net-2.6.24] iwlwifi: remove per-file CFLAGS for IWL  define
From: David Miller <davem@davemloft.net>
In-Reply-To: <11903436502774-git-send-email-yi.zhu@intel.com>
References: <11903436502774-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Fri, 21 Sep 2007 11:00:50 +0800

> From: Zhu Yi <chuyee@santarosa.sh.intel.com>
> 
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

I modified this to apply to my net-2.6.24 rebase where I moved
everything into a iwlwifi/ subdirectory.

Thanks.
