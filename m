Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47946 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab0LGSgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 13:36:01 -0500
Received: by qyk11 with SMTP id 11so5312172qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 10:36:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291746592.3607.53.camel@jlt3.sipsolutions.net>
References: <1291746157-14628-1-git-send-email-javier@cozybit.com> <1291746592.3607.53.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 7 Dec 2010 10:35:40 -0800
Message-ID: <AANLkTi=GYMS1oG0OX00CBqLhR2QyF7gfVgWsmmCN4oKF@mail.gmail.com>
Subject: Re: [PATCH v4] cfg80211/mac80211: add mesh join/leave commands
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bruno Randolf <br1@einfach.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Tue, Dec 7, 2010 at 10:29 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-12-07 at 10:22 -0800, Javier Cardona wrote:
>
>> v4: - wrap mesh sections inside CONFIG_MAC80211_MESH to
>>       fix compilation problems reported by Stephen Rothwell,
>>       Larry Finger and Bruno Randolf.
>
> Thanks, but since it was already applied we probably need a follow-on
> fixup patch?

Stephen did not apply it so I wasn't sure if John was going to revert
it as well.

I'll send a fixup patch and let them choose.

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
