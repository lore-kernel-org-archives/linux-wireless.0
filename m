Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34424 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2EWOfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 10:35:37 -0400
Received: by bkcji2 with SMTP id ji2so6029805bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 07:35:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ipfn6koz.fsf@purkki.adurom.net>
References: <1337760813-27055-1-git-send-email-arik@wizery.com>
 <87wr436utp.fsf@purkki.adurom.net> <CA+XVXfeju02Ou=jZ=eyq+0e4Rm1-5=b6-m8bMyZ8kAWO6F-sXQ@mail.gmail.com>
 <87mx4z6u4n.fsf@purkki.adurom.net> <CA+XVXfc3R8CrMfercPpRfYGjvKDdDkwJax+oLiaMrQQPwLCc0Q@mail.gmail.com>
 <87ipfn6koz.fsf@purkki.adurom.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 23 May 2012 17:35:20 +0300
Message-ID: <CA+XVXfcZAE0Drbn_JTBt1p0GAaFrsxZfHNE1Syp=1G=PNsvkbQ@mail.gmail.com> (sfid-20120523_163541_572439_88E57E9C)
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len
 for STA
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 23, 2012 at 5:22 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> We just enable the driver to override a default value, which is used
>> by mac80211.
>
> You are moving logic from mac80211 to the driver but it should be the
> opposite, the driver should be dumb and mac80211 should control
> everything. Didn't we have a similar discussion last year when talking
> about controlling dynamic power save?

I disagree. Not all mac80211 drivers are like ath9k. The
FW/lower-driver can be just as smart in certain areas (BA sessions for
instance).
Also, let's stay practical here. This is not a large and complex
feature like dynamic power save.

It's interesting to hear Johannes' take on this.

Arik
