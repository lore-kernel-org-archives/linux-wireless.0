Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:18394 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3BOKJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 05:09:41 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Julien Massot <jmassot@aldebaran-robotics.com>
Subject: Re: ath6kl: AR6004 failed to start on computer boot
References: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com>
Date: Fri, 15 Feb 2013 12:09:33 +0200
In-Reply-To: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com>
	(Julien Massot's message of "Mon, 10 Dec 2012 15:39:09 +0100")
Message-ID: <87ehghanxe.fsf@kamboji.qca.qualcomm.com> (sfid-20130215_110947_541909_B610BD5A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julien,

sorry for taking so long to get back to you.

Julien Massot <jmassot@aldebaran-robotics.com> writes:

> I have some problem with the AR6004 (hw 1.3) initialisation.
> I'm using the compat wireless 3.6.6-1 package, with the ath6kl driver from
>  https://github.com/kvalo/ath6kl.git. (master branch)
>
> The device seems not to respond after the firmware upload.
> "ath6kl: htc_wait_recv_ctrl_message: Timeout!"
> Increasing the timeout doesn't help.
> Here is the log at startup.
> http://pastebin.com/DsivqdDP
>
> If I unplug and re-plug the adapter, every thing is going well.
> http://pastebin.com/BTz0w5QL.
>
> Any Idea on how to fix or workaround this issue ?
>
> (I've also tried the recovery options recovery_enable=1 heart_beat_poll=200)

IIRC you mentioned on IRC that you don't see this anymore, is that
correct?

-- 
Kalle Valo
