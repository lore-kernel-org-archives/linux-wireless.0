Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1JJUFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 16:05:03 -0400
Subject: Re: [PATCH 06/29] wl12xx: add vifs list
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1318234397-21081-7-git-send-email-eliad@wizery.com> (sfid-20111010_101248_612345_25F9EE2E)
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-7-git-send-email-eliad@wizery.com>
	 (sfid-20111010_101248_612345_25F9EE2E)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 22:04:56 +0200
Message-ID: <1318277096.4001.1.camel@jlt3.sipsolutions.net> (sfid-20111010_220507_758012_015053E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote:
> keep a list of all the vifs associated with our hw.
> it will be later used in order to iterate through vifs.

What's wrong with ieee80211_iterate_active_interfaces() :-)

johannes

