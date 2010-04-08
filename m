Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f193.google.com ([209.85.222.193]:62301 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab0DHTNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:13:20 -0400
Received: by pzk31 with SMTP id 31so2600420pzk.33
        for <linux-wireless@vger.kernel.org>; Thu, 08 Apr 2010 12:13:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100408184106.GA2999@tuxdriver.com>
References: <1268161528-24028-1-git-send-email-sprecher.m@gmail.com>
	<43e72e891003091133h31bfb1c5sceb4d3c9258792e6@mail.gmail.com>
	<20100408184106.GA2999@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 8 Apr 2010 12:12:57 -0700
Message-ID: <t2o43e72e891004081212j3af7a42uce345ca3ae3bb816@mail.gmail.com>
Subject: Re: [PATCH] wireless: ath9k: Fix most coding style issues in ath9k
	This patch fixed up almost all coding style issues in the ath9k driver found
	by the ceckpatch.pl tool. Signed-off-by: Michael Sprecher
	<sprecher.m@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Sprecher <sprecher.m@gmail.com>, jmalinen@atheros.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 8, 2010 at 11:41 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Mar 09, 2010 at 11:33:44AM -0800, Luis R. Rodriguez wrote:
>> On Tue, Mar 9, 2010 at 11:05 AM, Michael Sprecher <sprecher.m@gmail.com> wrote:
>> > ---
>> >  drivers/net/wireless/ath/ath9k/ani.c         |    5 ++-
>> >  drivers/net/wireless/ath/ath9k/ath9k.h       |   28 ++++++++--------
>> >  drivers/net/wireless/ath/ath9k/beacon.c      |    6 ++--
>> >  drivers/net/wireless/ath/ath9k/btcoex.h      |    6 ++--
>> >  drivers/net/wireless/ath/ath9k/calib.c       |   15 ++++-----
>> >  drivers/net/wireless/ath/ath9k/calib.h       |    4 +-
>> >  drivers/net/wireless/ath/ath9k/common.c      |   20 +++++------
>> >  drivers/net/wireless/ath/ath9k/common.h      |   10 +++---
>> >  drivers/net/wireless/ath/ath9k/debug.c       |   12 +++---
>> >  drivers/net/wireless/ath/ath9k/eeprom.h      |    4 +-
>> >  drivers/net/wireless/ath/ath9k/eeprom_4k.c   |   16 +++++-----
>> >  drivers/net/wireless/ath/ath9k/eeprom_9287.c |   14 +++++---
>> >  drivers/net/wireless/ath/ath9k/eeprom_def.c  |   31 +++++++++---------
>> >  drivers/net/wireless/ath/ath9k/gpio.c        |    2 +-
>> >  drivers/net/wireless/ath/ath9k/hw.c          |   44 +++++++++++--------------
>> >  drivers/net/wireless/ath/ath9k/hw.h          |   22 ++++++------
>> >  drivers/net/wireless/ath/ath9k/init.c        |    6 ++--
>> >  drivers/net/wireless/ath/ath9k/mac.h         |    2 +-
>> >  drivers/net/wireless/ath/ath9k/main.c        |   26 +++++++-------
>> >  drivers/net/wireless/ath/ath9k/phy.c         |   12 +++----
>> >  drivers/net/wireless/ath/ath9k/phy.h         |    4 +-
>> >  drivers/net/wireless/ath/ath9k/rc.c          |   13 +++----
>> >  drivers/net/wireless/ath/ath9k/rc.h          |    4 +-
>> >  drivers/net/wireless/ath/ath9k/recv.c        |    5 +--
>> >  drivers/net/wireless/ath/ath9k/reg.h         |   22 ++++++------
>> >  drivers/net/wireless/ath/ath9k/virtual.c     |    3 +-
>> >  drivers/net/wireless/ath/ath9k/xmit.c        |   11 +++---
>> >  27 files changed, 167 insertions(+), 180 deletions(-)
>>
>> Thanks a lot! Unfortunately right now we have two large patch bombs
>> pending integration which would likely conflict with your patch. One
>> set which I hope we can get into 2.6.34-rc2, the ath9k_htc driver.
>> Then after that I have an already accumulated set of patches (count is
>> at 10 right now) for AR93xx work. The ar93xx work is not intended for
>> 2.6.34 though so I could rebase my work on top of yours but lets first
>> see ath9k_htc get merged first and decide then.
>>
>> So NACK for now.
>
> I think it is safe to rebase this now, if you are still interested... :-)

No wait, going to shoot out our massive series now :)

  Luis
