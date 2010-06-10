Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45957
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733Ab0FJFwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 01:52:32 -0400
Date: Wed, 09 Jun 2010 22:52:43 -0700 (PDT)
Message-Id: <20100609.225243.179940910.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: orphan ipw2x00 drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100610014547.GA2318@tuxdriver.com>
References: <1276134269-2273-1-git-send-email-yi.zhu@intel.com>
	<20100610014547.GA2318@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 9 Jun 2010 21:45:47 -0400

> On Thu, Jun 10, 2010 at 09:44:29AM +0800, Zhu Yi wrote:
>> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
>> ---
>> Please let us know if someone is interested in maintaining these drivers.
> 
> Any chance of getting some hardware/firmware documentation?

Indeed.

I'm extremely disappointed that the only organization currently even
capable of fixing low level bugs in these drivers no longer is willing
to do so.

If documentation can't be provided so that others can maintain this
driver (not just few specific people, because some day those folks
might tire of maintaining this too) that would be a serious crime.
