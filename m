Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab0HWOJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:09:34 -0400
Subject: Re: 11h frequency change support in iwlwifi?
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "garkein@mailueberfall.de" <garkein@mailueberfall.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100823093615.36500@gmx.net>
References: <20100823093615.36500@gmx.net>
Content-Type: text/plain
Date: Mon, 23 Aug 2010 07:08:49 -0700
Message-Id: <1282572529.20674.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-23 at 02:36 -0700, garkein@mailueberfall.de wrote:
> Hello,
> 
> I would like to know whether the client side support for 11h frequency change on radar detection is supported in the iwlwifi driver (and/or mac80211 if relevant).
> 
> I've learned that there is some kind of protocol with which the AP tells all clients about a radar related frequency change, which allow the clients to seamlessly follow the AP to the new channel.
> 
> Apparently this is either not supported or working in Linux/iwlwifi as my 5100agn repeatedly just looses the AP if that changes the channel due to radar instead of seamlessly following it. (which is bad, no fun if the client looses internet ;-))
> 
> That why I'm asking whether this currently supported in iwlwifi/Linux and if so, what debug flags I should switch on to gain some more information on what might be going wrong.
> 
> 
Channel switch is supported in iwlwifi, what version of kernel you are
using, this feature was introduce no too long ago. Please use
debug=0x10000003 to debug any issue.

Thanks
Wey

