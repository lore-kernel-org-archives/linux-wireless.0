Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaAONT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:19:26 -0500
Message-ID: <1389791963.4338.4.camel@jlt4.sipsolutions.net> (sfid-20140115_141929_933481_B6C4006D)
Subject: Re: [RFC 6/9] mac80211: track CSA globally
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Jan 2014 14:19:23 +0100
In-Reply-To: <1389787494-7361-7-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130933_316362_11729B8F)
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	 <1389787494-7361-7-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140115_130933_316362_11729B8F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 13:04 +0100, Michal Kazior wrote:
> For CSA to be safe it needs to be treated the same
> way as radar detection, scanning and remain on
> channel - all of those (including CSA) must be
> mutually exclusive.

This I don't understand. Why couldn't you do a remain-on(some
other)-channel or scan while counting down the beacons?

johannes

