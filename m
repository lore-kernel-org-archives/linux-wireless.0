Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56506 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0KVRwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 12:52:12 -0500
Received: by iwn38 with SMTP id 38so246176iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 09:52:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTime_MPWoTkoHRt-MZuboXOzFAXpV29JVy4nt-Gn@mail.gmail.com>
References: <1290372517-6777-1-git-send-email-hauke@hauke-m.de> <AANLkTime_MPWoTkoHRt-MZuboXOzFAXpV29JVy4nt-Gn@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 22 Nov 2010 09:51:51 -0800
Message-ID: <AANLkTi=U=jei1+s+42ajPMVaEbkLxm3HCKCm3Oj5P359@mail.gmail.com>
Subject: Re: [PATCH 1/2] compat: backport Generic exponentially weighted
 moving average (EWMA)
To: Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 21, 2010 at 5:32 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Sun, Nov 21, 2010 at 12:48 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>
> Thanks Hauke! John, are you going to revert EWMA stuff? If so maybe I
> should wait to merge this.

For the record, I'll apply this until Bruno provides the v2, don't
want to leave compat-wireless hanging. We can revert it once the new
version is supplied.

  Luis
