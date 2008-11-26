Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:41927 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbYKZIVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 03:21:33 -0500
Received: by mu-out-0910.google.com with SMTP id g7so301838muf.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 00:21:31 -0800 (PST)
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH] ipw2200: increase scan timeout
Date: Wed, 26 Nov 2008 09:21:06 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>
References: <200811251809.55461.helmut.schaa@gmail.com> <1227637971.13619.262.camel@rc-desk>
In-Reply-To: <1227637971.13619.262.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811260921.06779.helmut.schaa@gmail.com> (sfid-20081126_092137_132459_7CE772BA)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 25. November 2008 schrieb reinette chatre:
> On Tue, 2008-11-25 at 09:09 -0800, Helmut Schaa wrote:
> > I have no idea in which situations the scan takes longer than 5 seconds to
> > complete but maybe it might even take longer than 10 seconds. Has anybody from
> > Intel insight into the firmware scan code?

> I do not have insight into the scan code ... but I can try to find out
> if there is something specific you need to know.

A worst case runtime estimation of the scan code would be interesting ;)

Helmut
