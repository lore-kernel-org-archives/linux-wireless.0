Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6649 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab1BWPVL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 10:21:11 -0500
Subject: Re: Help about Intel Centrino Advanced-N 6205 wifi card
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "jgq516@gmail.com" <jgq516@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1298444805-27178-1-git-send-email-jgq516@gmail.com>
References: <1298444805-27178-1-git-send-email-jgq516@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 07:06:25 -0800
Message-ID: <1298473585.5138.28.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Xiao,

On Tue, 2011-02-22 at 23:06 -0800, jgq516@gmail.com wrote:
> Hello all,
> 
> I have one Intel Centrino Advanced-N 6205 wifi card which need firmware iwlwifi-6000g2a-4.ucode to support it, but in intel website http://intellinuxwireless.org/?n=Downloads, only iwlwifi-6000g2a-5.ucode firmware exists, where can I download the official version
> 4 firmware? Thanks in advance!
> 
> I also got iwlwifi-6000g2a-4.ucode from one website but maybe it has some problems, this firmware works well with kernel 2.6.37-rc1,
> but it seems can't compatible with 2.6.36, there are some "Microcode SW error detected" when enable the card, pls see the following
> logs, why this error exist with 2.6.36 kernel but disappeared in 2.6.37-rc1 kernel? and unfortunately, I want to work with 2.6.36 kernel:(.
> 
If you need to stay with 2.6.36 kernel, please use compat-wireless which
contain all the necessary support for 6205 device, 
http://wireless.kernel.org/en/users/Download

The latest and offical supported firmware is iwlwifi-6000g2a-17.168.5.2

Thanks
Wey


