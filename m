Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60641
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754203AbYEHXVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 19:21:05 -0400
Date: Thu, 08 May 2008 16:20:59 -0700 (PDT)
Message-Id: <20080508.162059.42870104.davem@davemloft.net> (sfid-20080509_012005_713918_B1EB2935)
To: tomasw@gmail.com
Cc: johannes@sipsolutions.net, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: iwlwifi and tx info in skb->cb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1ba2fa240805081616l3f49d770pefd517076a06b3ef@mail.gmail.com>
References: <1ba2fa240805081528t45d7810cjfd553bf99daff096@mail.gmail.com>
	<1210285845.3547.81.camel@johannes.berg>
	<1ba2fa240805081616l3f49d770pefd517076a06b3ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Tomas Winkler" <tomasw@gmail.com>
Date: Fri, 9 May 2008 02:16:14 +0300

> On Fri, May 9, 2008 at 1:30 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >  Anyway, with the changes davem and I are making to actually save the
> >  *extra* copy we should be doing well. That's where you want to look for
> >  improvements.
> 
> This is just for the bridging case, isn't it?

No, all cases.

We're repeating a lot of information for you, over and over
again, it seems.  Developers often find this frustrating,
especially when they are trying to get their own work done.
