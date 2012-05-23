Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40617 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2EWLNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 07:13:42 -0400
Received: by dady13 with SMTP id y13so9604712dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 04:13:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mx4z6u4n.fsf@purkki.adurom.net>
References: <1337760813-27055-1-git-send-email-arik@wizery.com>
 <87wr436utp.fsf@purkki.adurom.net> <CA+XVXfeju02Ou=jZ=eyq+0e4Rm1-5=b6-m8bMyZ8kAWO6F-sXQ@mail.gmail.com>
 <87mx4z6u4n.fsf@purkki.adurom.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 23 May 2012 14:13:25 +0300
Message-ID: <CA+XVXfc3R8CrMfercPpRfYGjvKDdDkwJax+oLiaMrQQPwLCc0Q@mail.gmail.com> (sfid-20120523_131346_089014_6BA6072F)
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len
 for STA
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 23, 2012 at 1:59 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> We want to change this in wlcore. We've encountered compatibility
>> problems with some APs when we set ACs other than VO to U-APSD mode.
>
> Sounds like a hack to do this in the driver. Why can't mac80211 do it?

Well it may be an issue specific to our HW. We didn't want to change
the default behavior of all other mac80211 drivers.

I'm not sure what you mean by "hack" here. We just enable the driver
to override a default value, which is used by mac80211.

Arik
