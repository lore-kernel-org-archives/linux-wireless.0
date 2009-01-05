Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:39210 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbZAEMk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 07:40:28 -0500
Date: Mon, 5 Jan 2009 13:54:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Andi Kleen <andi@firstfloor.org>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
Message-ID: <20090105125415.GL496@one.firstfloor.org> (sfid-20090105_134036_432343_64FB1196)
References: <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org> <49619FF7.2030606@lwfinger.net> <1231143464.3286.1.camel@johannes>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231143464.3286.1.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Any explanation as to why there are no attempts?
> 
> It only sent two probe packets? Remember that zd1211 is rather rate

This was with rtl8180, not zd1211.

> control challenged. I don't know. nbd might be able to tell you more.

What is nbd? 

Anyways I can add printks and try to figure out more.

-Andi

-- 
ak@linux.intel.com
