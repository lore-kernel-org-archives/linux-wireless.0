Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55852 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbZAXOam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:30:42 -0500
Subject: Re: [PATCH] ath9k: Set TSF fix
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1232806972.4036.10.camel@johannes.local>
References: <20090124081542.50450@gmx.net>
	 (sfid-20090124_091614_136619_417AC6BC)  <1232806972.4036.10.camel@johannes.local>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 09:29:16 -0500
Message-Id: <1232807356.2870.23.camel@localhost.localdomain> (sfid-20090124_153047_546673_FED5A83B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-01-24 at 15:22 +0100, Johannes Berg wrote:
> On Sat, 2009-01-24 at 09:15 +0100, Alina Friedrichsen wrote:
> > It seems that some Atheros hardware more like this code for setting the TSF.
> 
> Why don't you back that claim by something more substantial?

Yeah, at *least* which hardware likes it better, and some regression
testing to ensure that other hardware doesn't break with the change.

Dan


