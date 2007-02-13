Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:23741 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932072AbXBNAF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 19:05:58 -0500
Message-ID: <45D24873.10308@linux.intel.com>
Date: Tue, 13 Feb 2007 15:23:31 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [ipw3945-devel] [ANNOUNCE] d80211 based driver for Intel PRO/Wireless  3945ABG
References: <45CCE3CA.4050904@linux.intel.com> <20070210004620.GA5959@gamma.logic.tuwien.ac.at>
In-Reply-To: <20070210004620.GA5959@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Norbert Preining wrote:
...
> Ahhh ... one thing: The LED on my Acer Laptop (TM3012) does not show up,
> maybe because I have CONFIG_D80211_LEDS off?

The LED code in iwlwifi isn't hooked up to the D80211 LED code yet.  If 
you'd file a bug at http://bughost.org regarding the LEDs being broken 
(if you haven't already) I would appreciate it.

Thanks,
James
