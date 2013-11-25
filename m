Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab3KYIv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 03:51:57 -0500
Message-ID: <1385369511.4443.2.camel@jlt4.sipsolutions.net> (sfid-20131125_095202_259284_334FF964)
Subject: Re: wireless tree status
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 25 Nov 2013 09:51:51 +0100
In-Reply-To: <1385326492.23961.10.camel@jlt4.sipsolutions.net> (sfid-20131124_215503_335794_81025238)
References: <1385326492.23961.10.camel@jlt4.sipsolutions.net>
	 (sfid-20131124_215503_335794_81025238)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-11-24 at 21:54 +0100, Johannes Berg wrote:
> John,
> 
> were you planning to pull 3.13-rc1 into wireless.git?

Same question for wireless-next btw, but I think you should definitely
pull it in there for the genetlink changes I made through the net tree
recently. Otherwise we'll get conflicts in nl80211 for everything. In
fact even in wireless.git I believe we'd get conflicts but those are
less interesting (some bug fixes I have pending conflict slightly with
the genl changes).

johannes

