Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:63082 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbZHZW0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 18:26:24 -0400
Received: by iwn42 with SMTP id 42so406586iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 15:26:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251324755.20531.0.camel@johannes.local>
References: <850984.89698.qm@web23108.mail.ird.yahoo.com> <1251297273.15619.11.camel@johannes.local>
	<43e72e890908261333m1d576fdhaa16088affec5426@mail.gmail.com>
	<43e72e890908261506h6b9ec4efq2d190388663d4671@mail.gmail.com>
	<1251324755.20531.0.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 Aug 2009 15:26:06 -0700
Message-ID: <43e72e890908261526g538eea56l873314e576331449@mail.gmail.com>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: htl10@users.sourceforge.net,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 3:12 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Wed, 2009-08-26 at 15:06 -0700, Luis R. Rodriguez wrote:
>
>> > Neat, thanks. Not sure if I'll get to this this anytime soon, but if
>> > someone is interested in it please give it a shot and send a patch.
>> > That would be nice.
>>
>> What if we *also* just do that from mac80211 as well upstream?
>
> Why?

I was thinking of the case where someone hit rfkill between dev_open()
and mac80211's subif_open() but I am either not sure if this is
possible.

> It's fine as it is, and we don't want to clutter all cfg80211
> drivers with it.

If there is a real value to adding it to mac80211 then we wouldn't
need to tug around a hunk for it on compat.

  Luis
