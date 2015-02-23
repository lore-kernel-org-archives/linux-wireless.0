Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33325 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbbBWQcN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 11:32:13 -0500
Message-ID: <1424709127.3075.20.camel@sipsolutions.net> (sfid-20150223_173216_856137_4451FC66)
Subject: Re: [RFC] mac80211: use rhashtable for station table
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>
Date: Mon, 23 Feb 2015 17:32:07 +0100
In-Reply-To: <54DE76F2.4080107@candelatech.com>
References: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net>
	 <54DE76F2.4080107@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-02-13 at 14:13 -0800, Ben Greear wrote:

> Oooh, maybe finally time to mix local addr with peer addr to
> make lots of vifs connected to same AP hash well too? :)

As we discussed before, mixing it in isn't actually possible. Your patch
will get easier to maintain (if you also convert it) though :)

johannes

