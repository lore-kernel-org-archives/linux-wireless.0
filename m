Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bluebottle.com ([176.9.67.91]:53702 "EHLO
	mail.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbbIWI7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 04:59:12 -0400
Date: Wed, 23 Sep 2015 10:49:35 +0200
From: Bastian Bittorf <bittorf@bluebottle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: minstrel[_ht]: remove non-ascii debugfs
 characters
Message-ID: <20150923084935.GD6319@medion.lan> (sfid-20150923_105920_696562_4775F523)
References: <1442997041-8916-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442997041-8916-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Johannes Berg <johannes@sipsolutions.net> [23.09.2015 10:44]:
> Replace the average symbol by "avg" to avoid being warned about the
> non-ASCII symbol all the time, line up the columns properly.

who warns you? the compiler? the terminal?

bye, bastian
