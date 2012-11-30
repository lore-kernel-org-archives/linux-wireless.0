Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2K3MNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:13:35 -0500
Message-ID: <1354277637.10035.22.camel@jlt4.sipsolutions.net> (sfid-20121130_131337_573853_1242EB5F)
Subject: Re: [RFCv2 11/13] mac80211: add awake window IE to mesh beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org
Date: Fri, 30 Nov 2012 13:13:57 +0100
In-Reply-To: <1353701934-12752-12-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-12-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:
> The awake window value is announced in an IE in beacons if the local STA
> is in light or deep sleep mode towards any peer or non-peer. On receipt STA
> parse the IE.

Since you don't do anything with it I'd suggest moving the parsing to
the patch that uses it.

johannes

