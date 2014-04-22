Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:43921 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbaDVQcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 12:32:25 -0400
Received: by mail-lb0-f176.google.com with SMTP id 10so4550356lbg.35
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 09:32:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140422180003.6438dbb7@xenia.leun.net>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com> <20140422180003.6438dbb7@xenia.leun.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 22 Apr 2014 09:32:03 -0700
Message-ID: <CAB=NE6URp2S9rhVr2cqT+4VOj50m+q0o1rVRehCZvcUtNwTVVw@mail.gmail.com> (sfid-20140422_183228_348997_8E0E4E09)
Subject: Re: [PATCH 0/2] cfg80211: two reg fixes
To: Michael Leun <lkml20140418@newton.leun.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 9:00 AM, Michael Leun
<lkml20140418@newton.leun.net> wrote:
> Did I get this correct, test-ariks-patch-for-314.patch is the same
> thing as the two patches you posted and that got applied? If so, that
> does not help for 3.14, I fear. I might try them on an current 3.15-rc.

No its just one patch, the first one. I'll have another look at this,
do you happen to have gdb? Can you do:

gdb net/wireless/cfg80211.ko
l *reg_todo+0xc1

  Luis
