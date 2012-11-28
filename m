Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab2K1MxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:53:25 -0500
Message-ID: <1354107229.9345.15.camel@jlt4.sipsolutions.net> (sfid-20121128_135337_209541_2A9F3D8A)
Subject: Re: [PATCHv2] mac80211: Reject setting masked mac addresses
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 13:53:49 +0100
In-Reply-To: <1354036986-30027-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121127_182313_362852_4DDE091A)
References: <1354031029-7956-1-git-send-email-helmut.schaa@googlemail.com>
	 <1354036986-30027-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20121127_182313_362852_4DDE091A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 18:23 +0100, Helmut Schaa wrote:
> If a driver registers an address mask we should ensure that no interface
> gets an address assigned that isn't covered by the registered address
> mask.

Applied with a few changes, please check.

johannes

