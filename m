Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64564 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2FGS3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 14:29:50 -0400
Received: by yhmm54 with SMTP id m54so672704yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 11:29:49 -0700 (PDT)
Message-ID: <4FD0F319.3060306@lwfinger.net> (sfid-20120607_202953_423196_9DC3E2C7)
Date: Thu, 07 Jun 2012 13:29:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: Andre Heider <a.heider@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i]
 >= n_queues))
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com> <1339014959.4523.0.camel@jlt3.sipsolutions.net> <CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com> <1339053364.4517.0.camel@jlt3.sipsolutions.net> <CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com> <20120607180325.7752b3c0@milhouse> <4FD0E3F3.2060900@lwfinger.net> <20120607193027.05389791@milhouse>
In-Reply-To: <20120607193027.05389791@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2012 12:30 PM, Michael Büsch wrote:
> On Thu, 07 Jun 2012 12:25:07 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> I do not understand what is different about your system than mine.
>
> I think the difference is that he runs opensource firmware, for which the queuenumber
> patching comes into effect. You should be able to reproduce even with standard
> firmware by disabling QOS with the module parameter.

Loading b43 with the qos=0 option works, but using the open-source firmware does 
fail.

Larry



