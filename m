Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437AbXIGP2L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 11:28:11 -0400
Subject: Re: rtl8187 on realtek 8189
From: Dan Williams <dcbw@redhat.com>
To: maximilian attems <max@stro.at>
Cc: flamingice@sourmilk.net, andreamrl@tiscali.it,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070907111218.GD16304@stro.at>
References: <20070907111218.GD16304@stro.at>
Content-Type: text/plain
Date: Fri, 07 Sep 2007 11:27:41 -0400
Message-Id: <1189178861.2612.11.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-09-07 at 13:12 +0200, maximilian attems wrote:
> hello guys,
> 
> tried to get the wireless of the latest medion working,
> but simple pci id addition seems not enough, can't see
> any access point.
> what info do you need?
> 
> also why the hack is the interface wlan0 and not ethX?

Names mean nothing, ignore them, just use them.  Older cards used ethX
because they actually _do_ pass up ethernet-framed packets.  It's not a
hack.

Dan


