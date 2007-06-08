Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3247 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbXFHTYb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 15:24:31 -0400
Date: Fri, 8 Jun 2007 15:11:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: zergavis <zergavis@o2.pl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211 "wme.c:398" error
Message-ID: <20070608191108.GA4389@tuxdriver.com>
References: <1279688715.20070608205031@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1279688715.20070608205031@o2.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 08, 2007 at 08:50:31PM +0200, zergavis wrote:

> My name is Pawel Bieniek, and I'm new on this list.
> 
> Today I was trying to compile mac80211 into my kernel (2.6.21.4) on
> archlinux. I need it to run intel 4965AGN on my toshiba satelite A200
> notebook.
> 
> Unfortunately, it returns an error during compilation:
> 
> net/mac80211/wme.c: In function 'wme_qdiscop_destroy':
> net/mac80211/wme.c:358: warning: implicit declaration of function 
> 'tcf_destroy_chain'
> net/mac80211/wme.c: In function 'wme_qdiscop_init':
> net/mac80211/wme.c:398: warning: dereferencing 'void *' pointer
> net/mac80211/wme.c:398: error: request for member 'wiphy' in something not 
> a structure or union
> 
> Could someone help me handle with this?

Sounds like the intellinuxwireless.org guys need to add something to
their kcompat patches...

John
-- 
John W. Linville
linville@tuxdriver.com
