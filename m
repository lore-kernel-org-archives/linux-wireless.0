Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:41957 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZJUGuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 02:50:00 -0400
Received: by iwn8 with SMTP id 8so3365485iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 23:50:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910211107.58111.kunal.gangakhedkar@gmail.com>
References: <200910202112.30660.kunal.gangakhedkar@gmail.com>
	<411169.20125.qm@web55305.mail.re4.yahoo.com> <43e72e890910201620l3e475630wbde71f34fca3b6df@mail.gmail.com>
	<200910211107.58111.kunal.gangakhedkar@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 21 Oct 2009 15:49:44 +0900
Message-ID: <43e72e890910202349g474a79fehf3fcc4d66837e70b@mail.gmail.com>
Subject: Re: [ath9k-devel] Test for N-mode from userspace?
To: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>
Cc: austinxxh-ath9k@yahoo.com, ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2009 at 2:37 PM, Kunal Gangakhedkar
<kunal.gangakhedkar@gmail.com> wrote:
> On Wednesday 21 Oct 2009 4:50:18 am Luis R. Rodriguez wrote:
>> On Wed, Oct 21, 2009 at 2:28 AM, xxiao <austinxxh-ath9k@yahoo.com> wrote:
>> > interesting, why is MCS range just 0-7, which means no HT?
>>
>> MCS 1-7 is for single stream devices.
>>
>> http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
>
> So, does this mean that I can use N-mode on this device?

Yes, MCS 7 is your highest rate on your card.

  Luis
