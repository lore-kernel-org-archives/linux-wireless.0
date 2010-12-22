Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50906 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab0LVOiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:38:15 -0500
Received: by iwn9 with SMTP id 9so5279090iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:38:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikPBsA5T-Jxzpd09_gihqaP7xTZgLfHEvDMVmfp@mail.gmail.com>
References: <20101222102032.13401.10967.stgit@localhost6.localdomain6> <AANLkTikPBsA5T-Jxzpd09_gihqaP7xTZgLfHEvDMVmfp@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Dec 2010 09:37:55 -0500
Message-ID: <AANLkTim-Dj-oSdKBXtO=3F1sFTaVE=4RD3Jbc00nBD=i@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Move mac80211 functions into new file
To: sedat.dilek@gmail.com
Cc: Bruno Randolf <br1@einfach.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 7:08 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Wed, Dec 22, 2010 at 11:20 AM, Bruno Randolf <br1@einfach.org> wrote:
>> Move mac80211 functions into new file mac80211-ops.c to have a better
>> separation and to make base.c smaller.
>>
>> Signed-off-by: Bruno Randolf <br1@einfach.org>
>> ---
>>  drivers/net/wireless/ath/ath5k/Makefile       |    1
>>  drivers/net/wireless/ath/ath5k/base.c         |  763 ++-----------------------
>>  drivers/net/wireless/ath/ath5k/mac80211-ops.c |  774 +++++++++++++++++++++++++
>>  3 files changed, 825 insertions(+), 713 deletions(-)

How about just a main.c ?

  Luis
