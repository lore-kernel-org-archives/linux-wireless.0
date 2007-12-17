Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56811 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758713AbXLQVH6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 16:07:58 -0500
Subject: Re: [patch 2/9] iwlwifi: Resync rate control code with mac80211
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197892081.4885.18.camel@johannes.berg>
References: <20071217012517.882216322@gmx.de> >
	 <20071217012550.045470580@gmx.de> >
	 (sfid-20071217_012730_052104_5B10C305)  <1197892081.4885.18.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 22:07:55 +0100
Message-Id: <1197925675.7505.15.camel@localhost> (sfid-20071217_210800_210096_1D5873E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-17 at 12:48 +0100, Johannes Berg wrote:
> On Mon, 2007-12-17 at 02:25 +0100, Mattias Nissler wrote:
> > This brings iwlwifi rate control code back in sync with mac80211.
> 
> This, and a patch to fix the "simple" algorithm should be part of the
> first patch to avoid breaking bisection.

Ok, I'll merge them.

Mattias

