Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35534 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab1ESANs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 20:13:48 -0400
Subject: Re: [PATCH 1/1] nl80211: check return code for genlmsg_end
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1305759898.8827.7.camel@jlt3.sipsolutions.net>
References: <1305555848-17609-1-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110516_162725_013623_B6AF7B8A)  <1305759898.8827.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 17:10:27 -0700
Message-ID: <1305763827.10450.19.camel@wwguy-ubuntu> (sfid-20110519_021351_615868_BA4848E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-18 at 16:04 -0700, Johannes Berg wrote:
> On Mon, 2011-05-16 at 07:24 -0700, Wey-Yi Guy wrote:
> > Check the return value for genlmsg_end and handle it.
> 
> It can never return < 0:
> 
> /**
>  * nlmsg_end - Finalize a netlink message
>  * @skb: socket buffer the message is stored in
>  * @nlh: netlink message header
>  *
>  * Corrects the netlink message header to include the appeneded
>  * attributes. Only necessary if attributes have been added to
>  * the message.
>  *
>  * Returns the total data length of the skb.
> 

do we should remove all the checking all together?

Wey
> 


