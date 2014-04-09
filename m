Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53091 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932AbaDIMZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 08:25:32 -0400
Received: by mail-pb0-f51.google.com with SMTP id uo5so2431867pbc.24
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 05:25:31 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/8] cfg80211: remove unnecessary include clauses
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	<c02aba28b27fe39da9730cd965e322054815713f.1397006688.git.gamerh2o@gmail.com>
	<1397029770.4964.2.camel@jlt4.sipsolutions.net>
Date: Wed, 09 Apr 2014 20:25:23 +0800
In-Reply-To: <1397029770.4964.2.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Wed, 09 Apr 2014 09:49:30 +0200")
Message-ID: <87d2gqg05o.fsf@gmail.com> (sfid-20140409_142536_041270_858D6F69)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 09:49:30 +0200, Johannes Berg wrote:
> I don't like those last four patches, I'd rather have more includes than
> rely on other headers including headers that we need - that could change
> after all.

As I said in commit log, duplicate including could hide some warnings.

In theory, the possibility of change is equal, either it's a directly
included header or a indirectly included header, and it's more likely to
change to include more, not less. So the change may not cause any
problem.

In other way, the local directory header files may change more
frequently than the header files in include/ directory. Whether it's a
total win to apply the last four patches may be a question, but it's
just amusing to see that lots of lines can be deleted. :-)

>
> johannes
