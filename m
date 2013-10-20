Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:59903 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3JTJz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Oct 2013 05:55:29 -0400
Received: by mail-la0-f43.google.com with SMTP id el20so1783575lab.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Oct 2013 02:55:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382120516.14393.21.camel@jlt4.sipsolutions.net>
References: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
 <1381797731-2454-2-git-send-email-mcgrof@do-not-panic.com>
 <20131018180107.GG28130@tuxdriver.com> <1382120516.14393.21.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sun, 20 Oct 2013 11:55:07 +0200
Message-ID: <CAB=NE6XqSonLcD1qLSUCfUFyMJNeK-e9V=h6+UdOXGZnOhg3fQ@mail.gmail.com> (sfid-20131020_115532_693956_A650B6ED)
Subject: Re: [PATCH 1/6] cfg80211: export reg_initiator_name()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 18, 2013 at 8:21 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2013-10-18 at 14:01 -0400, John W. Linville wrote:
>> I'm going to merge this series, including the cfg80211.h change...FYI!
>
> I already have this patch though, hmm.

I have another series similar to this coming up soon but much more
intrusive, it'll deal with cfg80211 / nl80211 flags and tons of
drivers use them. I'll just post it to both and you guys can decide
what tree this goes in. Just giving an early heads up now.

  Luis
