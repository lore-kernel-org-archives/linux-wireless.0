Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36122 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbbLLAGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 19:06:39 -0500
Date: Sat, 12 Dec 2015 09:05:01 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [linux-next] iwl_mvm_get_key_sta_id() suspicious RCU usage
Message-ID: <20151212000501.GA579@swordfish> (sfid-20151212_010643_523773_799D8F40)
References: <20151211134418.GA29351@swordfish>
 <1449841741.2324.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449841741.2324.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On (12/11/15 14:49), Johannes Berg wrote:
> On Fri, 2015-12-11 at 22:44 +0900, Sergey Senozhatsky wrote:
> 
> > [ 6385.246300] drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1226
> > suspicious rcu_dereference_protected() usage!
> > 
> 
> Funny, Laura Abbott also reported this bug earlier today :)
> 
> I've sent out a fix, you can see it here:
> https://patchwork.ozlabs.org/patch/555587/
> 

Great, thanks!

	-ss
