Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:15746 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S969363AbXFHUtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 16:49:21 -0400
Message-ID: <4669A477.9080203@linux.intel.com>
Date: Fri, 08 Jun 2007 11:48:23 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: zergavis <zergavis@o2.pl>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211 "wme.c:398" error
References: <1279688715.20070608205031@o2.pl>
In-Reply-To: <1279688715.20070608205031@o2.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zergavis wrote:
> Hi,
> 
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

I just uploaded mac80211-8.0.1.tgz at:

	http://intellinuxwireless.org/?p=mac80211?n=downloads

I ran a build tests against 2.6.18 and 2.6.21-rc1.

I did a run-time test on 2.6.21-rc1 (32-bit) w/ iwl3945 and CONFIG_NET_SCHED=y

Let me know if you have any more build issues.

Thanks,
James
