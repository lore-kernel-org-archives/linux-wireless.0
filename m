Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2LEJR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 04:17:29 -0500
Message-ID: <1354699072.9972.7.camel@jlt4.sipsolutions.net> (sfid-20121205_101732_698634_8DBEFE1C)
Subject: Re: [PATCH] mac80211: fixing the warning storm for budding chipsets
 without ampdu_action defined
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Dec 2012 10:17:52 +0100
In-Reply-To: <CABPxzYKrYPo9S-t6dSPS3qgwKcsaD=uoiAm2+naS7C6D=3KBOg@mail.gmail.com> (sfid-20121205_101332_218158_7832CE9D)
References: <CABPxzYKrYPo9S-t6dSPS3qgwKcsaD=uoiAm2+naS7C6D=3KBOg@mail.gmail.com>
	 (sfid-20121205_101332_218158_7832CE9D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 14:43 +0530, Krishna Chaitanya wrote:
> Warn once should suffice.

Indeed :)

> Eg: our driver doesn't support the ampdu_action yet, so
> seeing a lot of warnings, hence the check for any
> new drivers to avoid messing the kernel log.

Please make the subject active voice ("fix the warning storm [...]").

Your patches are all whitespace damaged.

$ git am -s /tmp/\[PATCH\]_mac80211\:_fixing_the_warning_storm_for_budding_chipsets_without_ampdu_action_defined.mbox
Applying: mac80211: fixing the warning storm for budding chipsets without ampdu_action defined
fatal: corrupt patch at line 10
Patch failed at 0001 mac80211: fixing the warning storm for budding chipsets without ampdu_action defined
The copy of the patch that failed is found in:
   /home/johannes/sys/wireless/.git/rebase-apply/patch
When you have resolved this problem, run "git am --resolved".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

johannes

