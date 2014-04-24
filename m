Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbaDXIuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 04:50:35 -0400
Message-ID: <1398329415.4154.1.camel@jlt4.sipsolutions.net> (sfid-20140424_105042_437034_1A09C60B)
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP
 firmware
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Thu, 24 Apr 2014 10:50:15 +0200
In-Reply-To: <CA+BoTQkBCGyKYDaOMgdCi4Yw+SXeuRS+t0rGE8o=8+x2q5N74w@mail.gmail.com> (sfid-20140424_104431_792919_3603D338)
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
	 <CA+BoTQkBCGyKYDaOMgdCi4Yw+SXeuRS+t0rGE8o=8+x2q5N74w@mail.gmail.com>
	 (sfid-20140424_104431_792919_3603D338)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-24 at 10:44 +0200, Michal Kazior wrote:

> I think Monitor operation should be performed on a best effort basis.
> This means monitor_start/stop should be attempted once number of
> non-monitor vdevs changes.
> 
> We should probably introduce a ath10k_recalc_monitor() for that purpose.

Doesn't mac80211 do that for you?

See IEEE80211_HW_WANT_MONITOR_VIF.

johannes

