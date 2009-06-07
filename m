Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:19099 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZFGPEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 11:04:38 -0400
Message-ID: <4A2BD706.1040100@hartkopp.net>
Date: Sun, 07 Jun 2009 17:04:38 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-06-04
References: <20090604152011.GC2839@tuxdriver.com> <20090607.033751.191866033.davem@davemloft.net> <4A2BCC41.1060508@hartkopp.net> <20090607145830.GA2736@tuxdriver.com>
In-Reply-To: <20090607145830.GA2736@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sun, Jun 07, 2009 at 04:18:41PM +0200, Oliver Hartkopp wrote:
>> scripts/kconfig/conf -o arch/x86/Kconfig
>> .config:614:warning: symbol value 'm' invalid for RFKILL_INPUT
> 
> That functionality is no longer available as a module.  If you need
> it, then select Y.
> 
> Hth!

It does! Thanks for the clarification. I'll select CONFIG_RFKILL=y now.

Oliver

