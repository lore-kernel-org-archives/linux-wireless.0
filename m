Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbcETOIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 10:08:32 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Daniel Lenski <dlenski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
	<wrfjinyayf2i.fsf@redhat.com>
	<CAOw_LSHnV+244fT7YvEoV+7VSH_+OoGFmZSdGK4a3NqB407VGQ@mail.gmail.com>
Date: Fri, 20 May 2016 10:08:30 -0400
In-Reply-To: <CAOw_LSHnV+244fT7YvEoV+7VSH_+OoGFmZSdGK4a3NqB407VGQ@mail.gmail.com>
	(Daniel Lenski's message of "Thu, 19 May 2016 21:51:43 -0700")
Message-ID: <wrfj4m9svn35.fsf@redhat.com> (sfid-20160520_160835_577886_5344E848)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Lenski <dlenski@gmail.com> writes:
> You're welcome, and thanks for writing this great driver. It really
> makes a huge difference for stability of the Yoga 13 wifi!

You're welcome! It made a big difference for my own Yoga 13 and it's
been an exciting project. I learned a lot in the process.

> Unfortunately, I ran into a case today where even 5000 loops was not
> enough after a cold boot. 5000 loops meant about 1.5 second delay
> between finishing the firmware checksum poll, while waiting for the
> firmware to start. It now appears to me that the number of required
> polling loops must be strongly bimodal.
>
> I added some logging, so that the driver reports to me the number of
> loops required for the firmware to start.

This is bizarre, I wonder if the hardware is having issues in your
laptop? Another thing to try would be to do an additional reset of the
chip and wait a bit before trying to load the firmware?

Cheers,
Jes
