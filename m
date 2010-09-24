Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63035 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0IXVIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 17:08:36 -0400
Date: Fri, 24 Sep 2010 14:08:33 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"ext John W. Linville" <linville@tuxdriver.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH v3] omap: beagle: add support for wl1271 on the board
 file
Message-ID: <20100924210833.GJ4211@atomide.com>
References: <1285236215-21136-1-git-send-email-luciano.coelho@nokia.com>
 <20100924180316.GE8077@tuxdriver.com>
 <1285354249.9779.3.camel@powerslave>
 <20100924191139.GI4211@atomide.com>
 <AANLkTimixgHuhKYRP9X17V+z20T70Pn0vJJEsO_HgXQ4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimixgHuhKYRP9X17V+z20T70Pn0vJJEsO_HgXQ4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Gadiyar, Anand <gadiyar@ti.com> [100924 12:13]:
> On Sat, Sep 25, 2010 at 12:41 AM, Tony Lindgren <tony@atomide.com> wrote:
> 
> This seems to be a generic problem that many boards with potential for
> adding expansion boards seem to have. How about one of these options:
> (a) having u-boot modify ATAGS_REVISION based on an environment variable
> or
> (b) add a generic board_revision kernel command line parameter that
> each such board file can parse

There is already system_rev that can be used for that and has an
ARM generic atag for it. Just needs to be passed from u-boot,
and should have setenv option for it in u-boot also.

Tony
