Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27405 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbYI3QXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 12:23:30 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 09:23:30 -0700
Date: Tue, 30 Sep 2008 09:23:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [RFC v4] mac80211: re-enable aggregation on 2.6.27
Message-ID: <20080930162317.GA5919@tesla> (sfid-20080930_182335_854332_EDE2EC64)
References: <1222790548-7391-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1222790548-7391-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 30, 2008 at 09:02:28AM -0700, Luis Rodriguez wrote:
> This guy uses list_for_each_entry()

I meant  list_for_each_entry_safe() of course :)

> and shuffles locking
> handling a bit. It leaves locking as it used to 

as it used to be before I meant

> for our
> driver amdpu handler. I'm about to test it.

It also cancels sta_ba_session_work during sta_info_stop().

  Luis
