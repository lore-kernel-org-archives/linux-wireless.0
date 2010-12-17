Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:46962 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab0LQTxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 14:53:01 -0500
Received: by iyf40 with SMTP id 40so310581iyf.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 11:53:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292579343.3715.1.camel@jlt3.sipsolutions.net>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
 <1292556197-4820-3-git-send-email-lrodriguez@atheros.com> <1292579343.3715.1.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 17 Dec 2010 11:34:14 -0800
Message-ID: <AANLkTin4u4+NMc3K-1k8wmjrx6DP6=Ffbdt3omOjCAcq@mail.gmail.com>
Subject: Re: [RFC 2/8] cfg80211: process new country regulatory flags (DFS)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 17, 2010 at 1:49 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-12-16 at 19:23 -0800, Luis R. Rodriguez wrote:
>
>> + * @NL80211_ATTR_REG_COUNTRY_FLAGS: Country specific regulatory flags.
>> + *   These are @NL80211_CFLAG_DFS_FCC_*
>
> How many FCCs are there? ;-)

Heh, yeah thanks.

  Luis
