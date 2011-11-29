Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab1K2Lhr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 06:37:47 -0500
Date: Tue, 29 Nov 2011 12:39:07 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111129113906.GA7299@redhat.com> (sfid-20111129_123806_337643_AB3B2FDB)
References: <20111129100727.GD2675@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111129100727.GD2675@tiehlicka.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal

On Tue, Nov 29, 2011 at 11:07:27AM +0100, Michal Hocko wrote:
> [I am not sure whether this is ieee80211 or iwl3945 issue so put both
> maintainers into loop]
The only changed we had in iwlegacy between 3.1 and 3.2-rc, was only 
adjustment to mac80211 changes. However I think this is iwlegacy issue,
just for some reason bug did not trigger before.

Is this problem 100% reproducible for you ? If so I'll try to reproduce
it locally, otherwise I'll review related code to find reason of that
problem.

Thanks
Stanislaw 
