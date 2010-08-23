Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0HWOLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:11:24 -0400
Subject: Re: [PATCH 0/2] iw: add GeoClue support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, geoclue@lists.freedesktop.org,
	David.Quan@atheros.com, kevin@atheros.com
In-Reply-To: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
References: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 16:11:21 +0200
Message-ID: <1282572681.3813.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-20 at 20:29 -0400, Luis R. Rodriguez wrote:
> This series adds GeoClue support to iw.

Quite frankly, I don't see the point?

What use is a command line tool that has to talk to a whole bunch of
daemons etc.? I could see using say NM to connect it all, or maybe put
it into geoclue directly, but a command line to trigger it all seems
like a wrong approach?

johannes

