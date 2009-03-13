Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48869 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZCMPAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 11:00:34 -0400
Date: Fri, 13 Mar 2009 10:54:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: drop wext channel list if too long
Message-ID: <20090313145445.GC5551@tuxdriver.com> (sfid-20090313_160049_316222_72658912)
References: <1236882244.25931.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1236882244.25931.5.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2009 at 07:24:04PM +0100, Johannes Berg wrote:
> wext limits the number of channels it can list to 32, we obey
> that limitation but show a partial list which is confusing.
> Thus, when going over the limit, drop the list completely to
> make the users aware that something is wrong and hopefully
> prompt them to use iw instead. We still let iwlist print out
> the total number of available channels.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Will this make wpa_supplicant or Networkmanager barf?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
