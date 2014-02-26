Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33437 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaBZBJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 20:09:49 -0500
Received: by mail-pa0-f46.google.com with SMTP id rd3so216901pab.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 17:09:49 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux@eikelenboom.it,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 0/3] cfg80211: respin reprocessing pending requests
Date: Tue, 25 Feb 2014 17:09:39 -0800
Message-Id: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140226_021005_647381_2E74DAFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a respin. There are no code changes, I just adjusted the
commit logs as that's all the feedback I got from them, and on
the last patch I just don't think a timer is best. If a timer
is desired let me know how much time you want to set it for,
I just don't see how that's any better.

The commit log on the other ones should help let people make
decisions if the implications of not merging this, I'll let
folks make the call about whether or not some of these belong
to stable, I personally don't think so -- but some others may
disagree.

Luis R. Rodriguez (3):
  cfg80211: allow reprocessing of pending requests
  cfg80211: fix processing world regdomain when non modular
  cfg80211: processing regulatory requests on netdev notifier

 net/wireless/reg.c | 16 +++++++++-------
 net/wireless/reg.h |  1 +
 2 files changed, 10 insertions(+), 7 deletions(-)

-- 
1.8.5.3

