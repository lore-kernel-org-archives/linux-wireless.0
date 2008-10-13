Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46840
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbYJMEEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 00:04:12 -0400
Date: Sun, 12 Oct 2008 21:03:48 -0700 (PDT)
Message-Id: <20081012.210348.134156764.davem@davemloft.net> (sfid-20081013_060417_275334_DF481783)
To: johannes@sipsolutions.net
Cc: weiyi.huang@gmail.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: wireless: remove duplicated #include
From: David Miller <davem@davemloft.net>
In-Reply-To: <1223804937.10176.0.camel@johannes.berg>
References: <20081012171950.F6D8.WEIYI.HUANG@gmail.com>
	<1223804937.10176.0.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 12 Oct 2008 11:48:57 +0200

> On Sun, 2008-10-12 at 17:23 +0800, Huang Weiyi wrote:
> > Removed duplicated include <linux/list.h> in 
> > net/wireless/core.c.
> > 
> > Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Applied, thanks everyone.
