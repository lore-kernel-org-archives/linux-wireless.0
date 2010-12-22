Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51932 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0LVUac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 15:30:32 -0500
Received: by wyb28 with SMTP id 28so5451477wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 12:30:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim-Dj-oSdKBXtO=3F1sFTaVE=4RD3Jbc00nBD=i@mail.gmail.com>
References: <20101222102032.13401.10967.stgit@localhost6.localdomain6>
	<AANLkTikPBsA5T-Jxzpd09_gihqaP7xTZgLfHEvDMVmfp@mail.gmail.com>
	<AANLkTim-Dj-oSdKBXtO=3F1sFTaVE=4RD3Jbc00nBD=i@mail.gmail.com>
Date: Wed, 22 Dec 2010 22:30:31 +0200
Message-ID: <AANLkTimqcA2tXghmJjPir53ci7iZBghgGbWH-Wvfg3Wp@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Move mac80211 functions into new file
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: sedat.dilek@gmail.com, Bruno Randolf <br1@einfach.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/22 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Wed, Dec 22, 2010 at 7:08 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> On Wed, Dec 22, 2010 at 11:20 AM, Bruno Randolf <br1@einfach.org> wrote:
>>> Move mac80211 functions into new file mac80211-ops.c to have a better
>>> separation and to make base.c smaller.
>>>
>>> Signed-off-by: Bruno Randolf <br1@einfach.org>
>>> ---
>>>  drivers/net/wireless/ath/ath5k/Makefile       |    1
>>>  drivers/net/wireless/ath/ath5k/base.c         |  763 ++-----------------------
>>>  drivers/net/wireless/ath/ath5k/mac80211-ops.c |  774 +++++++++++++++++++++++++
>>>  3 files changed, 825 insertions(+), 713 deletions(-)
>
> How about just a main.c ?
>
>  Luis

We already have base.c, having both main.c and base.c could be
misleading, i think mac80211-ops.c is fine.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
