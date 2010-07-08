Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59310 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0GHUNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 16:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100708094548.GB1920@atomide.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-7-git-send-email-ohad@wizery.com> <2A3DCF3DA181AD40BDE86A3150B27B6B030E10C9B3@dbde02.ent.ti.com>
	<20100708094548.GB1920@atomide.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 8 Jul 2010 23:12:53 +0300
Message-ID: <AANLkTikHwy5d1-Wamt-dmjPRlrwyzuKw_9eJEN01SvBE@mail.gmail.com>
Subject: Re: [PATCH 06/15] omap zoom2: wlan board muxing
To: Tony Lindgren <tony@atomide.com>
Cc: "Ghorai, Sukumar" <s-ghorai@ti.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 8, 2010 at 12:45 PM, Tony Lindgren <tony@atomide.com> wrote:
>
> * Ghorai, Sukumar <s-ghorai@ti.com> [100708 06:34]:
> > > @@ -71,6 +71,21 @@ static struct twl4030_platform_data zoom2_twldata = {
> > >
> > >  #ifdef CONFIG_OMAP_MUX
> > >  static struct omap_board_mux board_mux[] __initdata = {
> > > +#ifdef CONFIG_OMAP_ZOOM_WLAN
> >
> > [Ghorai] This is zoom board specific file, So why need this additional flag?
>
> Good point, the ifdef is unnecessary in for both zoom2 and zoom3.
> Will update in my queue to remove the ifdefs.

Thanks a lot, Tony.

>
> Tony
