Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45356 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab1BAN44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 08:56:56 -0500
Subject: Re: [PATCH] mac80211: pass up beacons from external BSS when
 operating as AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296559385-5357-1-git-send-email-arik@wizery.com>
References: <1296559385-5357-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 14:56:54 +0100
Message-ID: <1296568614.3989.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-01 at 13:23 +0200, Arik Nemtsov wrote:
> Beacons from external BSSes are required for updating overlapping BSS
> info (i.e. ERP protection). Pass them up unconditionally.

Where will they be processed though?

johannes

