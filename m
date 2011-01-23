Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab1AWJGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 04:06:42 -0500
Subject: Re: [RFC][PATCH] cfg80211: report monitor interface channel via
 wext when possible
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Fertser <fercerpav@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Thomas d'Otreppe <tdotreppe@gmail.com>,
	Richard Farina <sidhayn@gmail.com>
In-Reply-To: <1295655098-17534-1-git-send-email-fercerpav@gmail.com>
References: <1295655098-17534-1-git-send-email-fercerpav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 10:06:39 +0100
Message-ID: <1295773599.3639.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-01-22 at 03:11 +0300, Paul Fertser wrote:
> This makes it possible to retrieve the channel for the monitor interface
> in cases when it can be determined unambigously. Tested with ath5k.

NAK.

http://article.gmane.org/gmane.linux.kernel.wireless.general/61860

johannes

