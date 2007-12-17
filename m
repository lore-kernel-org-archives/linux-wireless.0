Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51274 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755362AbXLQVJo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 16:09:44 -0500
Subject: Re: [patch 9/9] mac80211: Publish rc80211_pid parameters in debugfs
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197892956.4885.28.camel@johannes.berg>
References: <20071217012517.882216322@gmx.de> >
	 <20071217012550.634829179@gmx.de> >
	 (sfid-20071217_012738_052213_B631AA79)  <1197892956.4885.28.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 22:09:41 +0100
Message-Id: <1197925781.7505.21.camel@localhost> (sfid-20071217_210946_800188_93CC42BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-17 at 13:02 +0100, Johannes Berg wrote:
> > +	period = (HZ / 1000) * pinfo->sampling_period;
> 
> That isn't going to work correctly with HZ < 1000 because the
> parenthesised expression is going to be zero.

Right. There is another line in the patches that gets this wrong.

Mattias

