Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:32441 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752478AbXBIWfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 17:35:00 -0500
Message-ID: <45CCED20.90403@linux.intel.com>
Date: Fri, 09 Feb 2007 13:52:32 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
References: <45CCE3CA.4050904@linux.intel.com> <17868.62734.497825.667962@notabene.brown>
In-Reply-To: <17868.62734.497825.667962@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Neil Brown wrote:
> On Friday February 9, jketreno@linux.intel.com wrote:
>> Ok.  Now... any questions?
> 
> Yes.  Does this require a closed user-space helper like the other
> 3945ABG driver, or is it completely open (maybe excepting firmware)?

The iwlwifi driver for the 3945 does not require the user space daemon, 
but does require a new microcode image.

Over the past year we were able to make the necessary changes to the 
microcode used with the 3945 such that we were able to remove the 
regulatory daemon.

James
