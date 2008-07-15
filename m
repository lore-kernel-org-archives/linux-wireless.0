Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43760 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYGOHb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 03:31:26 -0400
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	<1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	<1216039127.11189.15.camel@johannes.berg>
	<1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	<87fxqcoaue.fsf@nokia.com>
	<1ba2fa240807141434k5260e6b9q6468b450fccba3e7@mail.gmail.com>
	<87od4zd34j.fsf@nokia.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 15 Jul 2008 10:30:43 +0300
In-Reply-To: <87od4zd34j.fsf@nokia.com> (ext Kalle Valo's message of "Tue\, 15 Jul 2008 10\:21\:16 +0300")
Message-ID: <87k5fnd2os.fsf@nokia.com> (sfid-20080715_093129_861914_0DE5CAE8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@nokia.com> writes:

>> This patch should go in and we can reconsider it when other HW
>> driver will implement PS so we can see the bigger picture.
>
> I guess it's a good compromise for now, but as long as we change it
> later.

Sorry, meant to say:

"but as long as we can change it later"

-- 
Kalle Valo
