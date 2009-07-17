Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49766 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbZGQHLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 03:11:16 -0400
Received: by fxm18 with SMTP id 18so551901fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 00:11:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907161615h507e9c59r421d23d22ff05459@mail.gmail.com>
References: <43e72e890907161615h507e9c59r421d23d22ff05459@mail.gmail.com>
Date: Fri, 17 Jul 2009 09:11:15 +0200
Message-ID: <a32f33a40907170011n38367961i54a26c50124241c2@mail.gmail.com>
Subject: Re: [KARMIC] review these for rt2x00 (adds rt2800pci)
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Stefan Bader <stefan.bader@canonical.com>,
	Manoj Iyer <manoj.iyer@canonical.com>,
	kernel-team@lists.ubuntu.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 1:15 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Thu, Jul 16, 2009 at 9:56 AM, Stefan Bader<stefan.bader@canonical.com> wrote:
>> At least this seems to be material for 3 or 4 patches
>> - adapt the rfkill stuff
>> - some documentation update
>> - add the new pci version of the 2800 (with that rt2x00soc lib
>>   which might be another patch)
>> - and some fixes...
>
> Not only that but this driver is not yet merged upstream, there should
> be a good reason for that.
>
> Ivo, what's the status on rt2800pci? Some users have been asking about it.

The status is that it is not functioning correctly, during boot it
will print out
tons of errors about the device not being ready, and afterward it cannot scan,
connect or do anything useful.

And I think those problems can be considered enough reasons for not merging
the driver upstream yet. ;)

Ivo
