Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64160 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1LHJlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 04:41:53 -0500
Received: by yenm11 with SMTP id m11so926863yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 01:41:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323336406.3332.9.camel@jlt3.sipsolutions.net>
References: <1323336114-31203-1-git-send-email-helmut.schaa@googlemail.com>
	<1323336302.3332.7.camel@jlt3.sipsolutions.net>
	<1323336406.3332.9.camel@jlt3.sipsolutions.net>
Date: Thu, 8 Dec 2011 10:41:52 +0100
Message-ID: <CAGXE3d-qyXB7cEaDM6-21FttyF6iNNGRG1_madFVC9d25X6tRA@mail.gmail.com> (sfid-20111208_104158_433756_61F042A0)
Subject: Re: [PATCH 1/2] ieee80211: Introduce ieee80211_has_frags
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 8, 2011 at 10:26 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> Would _is_frag() read nicer? The piece you're checking is a fragment I
>> think?
>
> Never mind ... the first fragment has is a fragment too and doesn't
> return true here.

We could also call it ieee80211_is_first_frag and swap the logic?
