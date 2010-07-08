Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50188 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0GHJqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 05:46:05 -0400
Date: Thu, 8 Jul 2010 12:45:48 +0300
From: Tony Lindgren <tony@atomide.com>
To: "Ghorai, Sukumar" <s-ghorai@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	"Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, "Ben-cohen, Ohad" <ohadb@ti.com>
Subject: Re: [PATCH 06/15] omap zoom2: wlan board muxing
Message-ID: <20100708094548.GB1920@atomide.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
 <1278376666-3509-7-git-send-email-ohad@wizery.com>
 <2A3DCF3DA181AD40BDE86A3150B27B6B030E10C9B3@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2A3DCF3DA181AD40BDE86A3150B27B6B030E10C9B3@dbde02.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Ghorai, Sukumar <s-ghorai@ti.com> [100708 06:34]:
> > @@ -71,6 +71,21 @@ static struct twl4030_platform_data zoom2_twldata = {
> > 
> >  #ifdef CONFIG_OMAP_MUX
> >  static struct omap_board_mux board_mux[] __initdata = {
> > +#ifdef CONFIG_OMAP_ZOOM_WLAN
>
> [Ghorai] This is zoom board specific file, So why need this additional flag?

Good point, the ifdef is unnecessary in for both zoom2 and zoom3.
Will update in my queue to remove the ifdefs.

Tony
