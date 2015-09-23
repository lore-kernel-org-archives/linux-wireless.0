Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bluebottle.com ([176.9.67.91]:47072 "EHLO
	mail.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbbIWJhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 05:37:52 -0400
Date: Wed, 23 Sep 2015 11:07:23 +0200
From: Bastian Bittorf <bittorf@bluebottle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bastian Bittorf <bittorf@bluebottle.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: minstrel[_ht]: remove non-ascii debugfs
 characters
Message-ID: <20150923090723.GF6319@medion.lan> (sfid-20150923_113755_939568_E81E70A8)
References: <1442997041-8916-1-git-send-email-johannes@sipsolutions.net>
 <20150923084935.GD6319@medion.lan>
 <1442998845.1889.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442998845.1889.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Johannes Berg <johannes@sipsolutions.net> [23.09.2015 11:03]:
> > > non-ASCII symbol all the time, line up the columns properly.
> > 
> > who warns you? the compiler? the terminal?
> 
> sparse, or perhaps smatch? either way, those tools are crucial for my
> workflow, and there seems to be very little downside to the change.

thanks for making this clear. bye, bastian
