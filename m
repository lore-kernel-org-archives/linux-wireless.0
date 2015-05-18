Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33799 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbbERJUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 05:20:21 -0400
Received: by wguv19 with SMTP id v19so119442188wgu.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 02:20:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431939927.2719.0.camel@sipsolutions.net>
References: <chaitanya.mgit@gmail.com> <1431939609-7261-1-git-send-email-chaitanya.mgit@gmail.com>
 <1431939927.2719.0.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 18 May 2015 14:49:59 +0530
Message-ID: <CABPxzYJ-3ctYOdek4RGkt95EKU7Z7qO5qB=8Pb=v+1QN0MCy5A@mail.gmail.com> (sfid-20150518_112032_768178_48A47724)
Subject: Re: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused by
 race between suspend and Tx packet.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2015 at 2:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Mon, 2015-05-18 at 14:30 +0530, chaitanya.mgit@gmail.com wrote:
> > From: Chaitanya T K <chaitanya.tata@imgtec.com>
> >
> > If we receive suspend after TX path has executed
> > dynamic ps disable work, the driver will be in
> > ACTIVE state during suspend and even after it
> > resumes.
> >
> > As before suspend all data packets are flushed
> > it is safe to put the driver in to sleep for
> > optimal power during suspend or up on resume.
>
> Please stop resending this patch a few times a day without indicating
> any changes.
>
> I'm going to ignore it for a few days now until this settles down.

My sendmail shows status as bounced so i was trying with different
options. I did not realize that it has already made it to the list.

Apologies for the trouble Johannes,
