Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:42011 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753883AbXDYFWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2007 01:22:41 -0400
Message-ID: <462EE107.8040005@linux.intel.com>
Date: Tue, 24 Apr 2007 22:03:03 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <20070423184814.7029.8413.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184814.7029.8413.stgit@magic.sourmilk.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> From: Michael Wu <flamingice@sourmilk.net>
> 
> The hw_scan callback breaks the auto AP selection code in ieee80211_sta.c.
> No in-tree drivers use it either. This patch removes it.

What is the specific problem that is being addressed by pulling hw offload scan support?  

(I would like to see hw_scan remain since iwlwifi uses it -- which we hope to submit as soon as the code restructuring is complete)

James
