Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48159 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966620Ab0GSWdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 18:33:05 -0400
Received: by wwj40 with SMTP id 40so1656wwj.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jul 2010 15:33:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279565034.4572.36.camel@localhost.localdomain>
References: <1279565034.4572.36.camel@localhost.localdomain>
Date: Tue, 20 Jul 2010 00:33:04 +0200
Message-ID: <AANLkTinGUQjPoMRmt_jeFgpxLhzma7qhfR14t_tWLvO1@mail.gmail.com>
Subject: Re: iwlagn and many firmware restarts with Fedora kernel
From: drago01 <drago01@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 19, 2010 at 8:43 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi,
>
> so during the last few weeks, I have seen a huge amount of firmware
> restarts with my Intel 5350 card and Fedora 13 kernel (2.6.33.6-147).
>
> iwlagn 0000:03:00.0: low ack count detected, restart firmware
> iwlagn 0000:03:00.0: On demand firmware reload
> iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
> iwlagn 0000:03:00.0: queue number out of range: 0, must be 10 to 19
>
> If this happens then I don't see it once, I normally see this 10-20
> times and the connectivity is stalled until the cards comes back to
> life. I have seen patches that should have fixed this symptom, but they
> might be also send to -stable since this is a major hassle.
>
> The time without connectivity is something around 4-5 minutes or longer
> when this happens. Not really funny.

This happens here too even with the 2.6.34.1-9.fc13.x86_64 kernel;
when this happens reloading the iwlagn module seems to be the only
(quick) way to get it back to life.
