Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:46814 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZJGUZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 16:25:29 -0400
Received: by mail-iw0-f178.google.com with SMTP id 8so3038179iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2009 13:25:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091007194148.GC22394@tuxdriver.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
	<1254876274-1145-8-git-send-email-lrodriguez@atheros.com>
	<20091007194148.GC22394@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 7 Oct 2009 16:24:58 -0400
Message-ID: <43e72e890910071324gba410cek3b8e5cb86311af38@mail.gmail.com>
Subject: Re: [PATCH 7/7] ath5k: enable Power-Save Polls by setting the
	association ID
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 7, 2009 at 3:41 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Oct 06, 2009 at 08:44:34PM -0400, Luis R. Rodriguez wrote:
>> mac80211 has long provided us the association ID. This isn't useful except
>> for Power-Save polling which now gets enabled. We can now poll for our
>> pending frames on the AP during power save.
>>
>> You can review the details of Power-Save on the wireless wiki:
>>
>> http://wireless.kernel.org/en/developers/Documentation/ieee80211/power-savings
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> Nice try, but how is this a fix? :-)

It isn't -- by no means do I want this in for 2.6.32, sorry if I was
misleading. Its a regression as things *used* to work :) but yeah not
a regression for 2.6.32.

  Luis
