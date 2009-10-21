Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbZJUSMf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 14:12:35 -0400
Subject: Re: [PATCH] libertas: remove unused
 lbs_cmd_802_11_inactivity_timeout()
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200910190854.19967.hs4233@mail.mn-solutions.de>
References: <200910161734.22840.hs4233@mail.mn-solutions.de>
	 <1255710571.14241.30.camel@localhost.localdomain>
	 <200910190854.19967.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 11:12:36 -0700
Message-Id: <1256148756.5010.34.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-10-19 at 08:54 +0200, Holger Schurig wrote:
> > We were going to use this at one point, but we haven't yet, so we can
> > add it back when we do.
> 
> So, what does this actually do?

Pretty much like it sounds; it lets the device go to into powersave at
user-specified interval after the last TX or RX, instead of having to
wait one full beacon of inactivity.

Dan


