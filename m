Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2KZPIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 10:08:23 -0500
Message-ID: <1353942528.2800.1.camel@jlt4.sipsolutions.net> (sfid-20121126_160826_131704_5CA02B6E)
Subject: Re: [RFC] mac80211: add debugfs file for mic failure
From: Johannes Berg <johannes@sipsolutions.net>
To: saravanad@posedge.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 16:08:48 +0100
In-Reply-To: <67d5ecb12773d91de180d654e6283cbe@posedge.com>
References: <67d5ecb12773d91de180d654e6283cbe@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 04:56 -0800, saravanad@posedge.com wrote:
> Add a debugfs file showing the number of failure of
> rx packet dropped due to mic failures. currently the
> number of rx packet dropped is counted in general and
> not with respect to a specific reason. This patch
> counts the number of packet drop due to mic failure.

What's the value of this, shouldn't wpa_s/hostapd start countermeasures
pretty quickly?

johannes

