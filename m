Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1JGHwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 03:52:14 -0400
Subject: Re: PATCH] mac80211: set no_cck also for hw_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
In-Reply-To: <CAFED-jn_FCppQ_=ue-3xCS=v_fyj5+bKkV-do3beGGH9TxpTOA@mail.gmail.com> (sfid-20111007_093617_787123_ED8DFECE)
References: <CAFED-j=0-J_H0g3tZoDAX2q8VVFzYfs2n3im07vWkKC_wdh_bA@mail.gmail.com>
	 <1317971874.3988.0.camel@jlt3.sipsolutions.net>
	 <CAFED-jn_FCppQ_=ue-3xCS=v_fyj5+bKkV-do3beGGH9TxpTOA@mail.gmail.com>
	 (sfid-20111007_093617_787123_ED8DFECE)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 09:52:07 +0200
Message-ID: <1317973927.3988.9.camel@jlt3.sipsolutions.net> (sfid-20111007_095217_788117_C9E6676B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-07 at 09:35 +0200, Janusz Dziedzic wrote:

> I have a small question also. How should/could I get latest
> compat-wireless with git history?
> git clone for compat-wireless.git from kernel.org seems not work yet??
> 
> In case I have tar ball - eg. compat-wireless-3.0-2.tar.bz2 - how
> could I find latest commit for this release?

Err, do you want compat-wireless's git history, or the git history for
the kernel it's based on? For the former, Luis moved to github (search
the mailing list archive) for now. For the latter, that's just
linux-next and the tarball contains the commit ID it was built from.

johannes

