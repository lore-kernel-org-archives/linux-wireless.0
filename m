Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488Ab3CDPyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:54:00 -0500
Message-ID: <1362412431.21028.38.camel@jlt4.sipsolutions.net> (sfid-20130304_165406_639169_D18BBEAF)
Subject: Re: Linux summit this year ?
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Matt Chen <machen@suse.com>, joeyli <jlee@suse.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 04 Mar 2013 16:53:51 +0100
In-Reply-To: <20130225211207.GE6455@tuxdriver.com> (sfid-20130225_221525_165018_E30D3F09)
References: <CALx5=V-wOkHb1Q4A_32LBQm9aP0dUL1J5s4ceLwqVGSYhfpwxw@mail.gmail.com>
	 <20130225143201.GA6455@tuxdriver.com> <1361809785.3902.19.camel@aeonflux>
	 <512BAED0.2000507@lwfinger.net> <20130225211207.GE6455@tuxdriver.com>
	 (sfid-20130225_221525_165018_E30D3F09)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-25 at 16:12 -0500, John W. Linville wrote:

> I would still like to do New Orleans.  I'm just not sure if we can
> fit it in.  I don't suppose that someone would like to propose it as
> a mini-conference for LPC?  Do we know what we want to discuss?

I think there's a large topic of discussion around multi-channel
management, i.e. how in particular wpa_supplicant should behave. We have
the low-level feature implemented, but no real strategy for its use
across the stack. We have some thoughts, use-cases etc. so this will
probably have to be done before the summit though.

johannes

