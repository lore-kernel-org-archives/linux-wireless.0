Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f181.google.com ([209.85.216.181]:62007 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0CED41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 22:56:27 -0500
Received: by pxi11 with SMTP id 11so126551pxi.15
        for <linux-wireless@vger.kernel.org>; Thu, 04 Mar 2010 19:56:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <646765f41003041954r6b11813al41248117dd383584@mail.gmail.com>
References: <1267760678-5421-1-git-send-email-lrodriguez@atheros.com>
	<1267760678-5421-4-git-send-email-lrodriguez@atheros.com>
	<646765f41003041954r6b11813al41248117dd383584@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 4 Mar 2010 19:56:07 -0800
Message-ID: <43e72e891003041956s1ec82aeatc3033e85f1a401b@mail.gmail.com>
Subject: Re: [RFC 3/3] ath9k: rename initvals.h to ar9200_initvals.h
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kevin@atheros.com, doug.dahlby@atheros.com,
	cliff.holden@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 4, 2010 at 7:54 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> On Fri, Mar 5, 2010 at 14:44, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
>> The register initialization values we have so far are
>> only for the AR5008, AR9002 and AR9002 hardware families
>> and we've managed to get ar90002_hw.c to be its only user
>> so clarify this by renaming the initvals.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/ar9002_hw.c         |    2 +-
>>  .../ath/ath9k/{initvals.h => ar9200_initvals.h}    |    0
>>  2 files changed, 1 insertions(+), 1 deletions(-)
>>  rename drivers/net/wireless/ath/ath9k/{initvals.h => ar9200_initvals.h} (100%)
>
> Should this possibly be ar9002_initvals.h as to match up with ar9002_hw.c?

Heh yeah thanks, good catch, will rename on my end.

  Luis
