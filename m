Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53043 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1HJNyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:54:52 -0400
Subject: Re: [PATCH 3/4] mac80211: Add HT helper functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <2346835.BL4CqEnUDP@alex-1> (sfid-20110808_140943_617659_52176005)
References: <1888623.Vt5VZUN2cU@alex-1>  <2346835.BL4CqEnUDP@alex-1>
	 (sfid-20110808_140943_617659_52176005)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:54:49 +0200
Message-ID: <1312984489.4325.11.camel@jlt3.sipsolutions.net> (sfid-20110810_155454_939077_494AD1DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-08 at 14:09 +0200, Alexander Simon wrote:
> these can also be used from existing code.

So you should say that it's a refactoring. Generally, your commit logs
could really be a tad more verbose :-)

I'm not going to really review the code you move here -- hopefully you
did only move it?

johannes


