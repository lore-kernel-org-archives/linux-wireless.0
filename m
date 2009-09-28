Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49593 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZI1Sav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 14:30:51 -0400
Date: Mon, 28 Sep 2009 14:29:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: Makefile ref to non-existent CONFIG_ATHEROS_AR71XX
Message-ID: <20090928182944.GA4737@tuxdriver.com>
References: <alpine.LFD.2.00.0909180959550.9988@localhost> <200909182004.54398.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200909182004.54398.florian@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 18, 2009 at 08:04:51PM +0200, Florian Fainelli wrote:
> Hi Robert,
> 
> Le vendredi 18 septembre 2009 16:01:25, Robert P. J. Day a écrit :
> >   searching for Makefile references to Kconfig variables that don't
> > exist, and i find:
> >
> > ===== ATHEROS_AR71XX =====
> > ./drivers/net/wireless/ath/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) +=
> > ahb.o
> 
> We need it in OpenWrt and plan to send Atheros AR71xx SoC support soon, do not 
> consider this for removal. Thanks

Sure, fine...estimate when it will arrive?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
