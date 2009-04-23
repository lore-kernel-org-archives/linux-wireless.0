Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:5926 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZDWSAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 14:00:00 -0400
Received: by fg-out-1718.google.com with SMTP id d23so38516fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 10:59:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1240508541.30082.259.camel@johannes.local>
References: <69e28c910904231036r131612e3vabdab0302659fb63@mail.gmail.com>
	<1240508541.30082.259.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 23 Apr 2009 19:59:44 +0200
Message-ID: <69e28c910904231059r544a4e35qbd3a948f0136f834@mail.gmail.com> (sfid-20090423_200006_860777_4AFCD2C8)
Subject: Re: [PATCH 2/5] mac80211: Fix handling of retry count of NO_ACK
	frames in PID
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/23 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2009-04-23 at 19:36 +0200, G=E1bor Stefanik wrote:
>> Make PID check
>
>
>> =A0rc80211_minstrel.c | =A0 =A08 +++++---
>> =A01 file changed, 5 insertions(+), 3 deletions(-)
>
> Hmmm.

Resend coming soon.

=46or some reason, my Linux install started overwriting the clipboard
when I select anything. (Previously, the select->middle-click and
Ctrl+C->Ctrl+V mechanisms worked independently.)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
