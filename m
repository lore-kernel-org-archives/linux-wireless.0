Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:18200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab1FTR2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 13:28:15 -0400
Received: from hpaq5.eem.corp.google.com (hpaq5.eem.corp.google.com [172.25.149.5])
	by smtp-out.google.com with ESMTP id p5KHS9gn023423
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 10:28:09 -0700
Received: from wyi11 (wyi11.prod.google.com [10.241.227.11])
	by hpaq5.eem.corp.google.com with ESMTP id p5KHS8CN030518
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 10:28:08 -0700
Received: by wyi11 with SMTP id 11so2677202wyi.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 10:28:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87aadc1s5j.fsf@purkki.adurom.net>
References: <1308425533-20854-1-git-send-email-arik@wizery.com>
	<1308471076.4145.6.camel@jlt3.sipsolutions.net>
	<20110620133535.GA2251@tuxdriver.com>
	<1308578353.4322.8.camel@jlt3.sipsolutions.net>
	<87aadc1s5j.fsf@purkki.adurom.net>
Date: Mon, 20 Jun 2011 10:28:08 -0700
Message-ID: <BANLkTikwj5Qqps_SOk_O6pkBUYbBgcwPxrvZ5skGOkXy7UVSkw@mail.gmail.com> (sfid-20110620_192819_912094_9E967150)
Subject: Re: [RFC] mac80211: dynamic PS - don't enter PS when TX frames are pending
From: Sam Leffler <sleffler@google.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 20, 2011 at 7:42 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>>> > FWIW, I don't really consider myself maintaining the PS
>>> > implementation ;-) I don't understand it and think the code is way too
>>> > complex.
>>>
>>> Perhaps Kalle can comment?  Or...?
>>
>> Yeah he's a good candidate :)
>
> Hehe :)
>
> But I agree with Johannes, the powersave in mac80211 is pretty
> complex. I lost track of it a long time ago so it's pretty difficult
> for me to comment about the patch.

I believe I've hit this situation (and have changes of my own to do
something similar but different); will review.

-Sam
