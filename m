Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48400 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760736Ab2COIrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 04:47:45 -0400
Subject: Re: wmm admission control in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Soumik Das <soumik_kgp@yahoo.co.uk>
Cc: "Divinsky, Yonatan" <yoni.divinsky@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1331792570.68534.YahooMailNeo@web28210.mail.ukl.yahoo.com>
References: <1323870210.97711.YahooMailNeo@web28203.mail.ukl.yahoo.com>
	 <1323871164.8146.0.camel@jlt3.sipsolutions.net>
	 <CANJm+iAm2pzESyLv8fmCkQYa6cD2HyxhAWN+eCGar_Q4gvd4xw@mail.gmail.com>
	 <1331792570.68534.YahooMailNeo@web28210.mail.ukl.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 09:47:39 +0100
Message-ID: <1331801259.3432.1.camel@jlt3.sipsolutions.net> (sfid-20120315_094805_130093_4BADEBC5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 06:22 +0000, Soumik Das wrote:
> Hi,
> 
> In the current driver operation (ieee80211_ops)  there is no provision for configuring medium time. But this would be essential for admission control.
> 
> Will it be better to add a new (optional) operation in ieee80211 or can we add a new field in ieee80211_tx_queue_params?

It seems a new TX queue field would be better, but keep in mind that not
all drivers/devices will support it.

johannes

