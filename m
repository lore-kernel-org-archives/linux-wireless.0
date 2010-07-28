Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50320 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab0G1RcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 13:32:20 -0400
Received: by iwn7 with SMTP id 7so4968662iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 10:32:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280299929.3832.3.camel@jlt3.sipsolutions.net>
References: <1280262788-9890-1-git-send-email-lrodriguez@atheros.com>
	<1280262788-9890-3-git-send-email-lrodriguez@atheros.com>
	<1280299929.3832.3.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 28 Jul 2010 10:31:59 -0700
Message-ID: <AANLkTikW=+0XkATzs6rjT1buCFULP65zhR-eab-b_Rb+@mail.gmail.com>
Subject: Re: [PATCH 2/3] mac80211_hwsim: supress scan conflict message
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 11:52 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-07-27 at 16:33 -0400, Luis R. Rodriguez wrote:
>> Johannes already debugged this and determined it was due
>> to a race condition in mac80211, in order to fix this though
>> we would need to change drivers quite a bit so for now just
>> supress this and we'll correct this on the next kernel release.
>
> This one can stay for all I care since it's not used in practise by
> actual users that get confused :-)

Whatever works.

  Luis
