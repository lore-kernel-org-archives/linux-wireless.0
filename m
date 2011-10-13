Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60320 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1JMSIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 14:08:36 -0400
Received: by vws1 with SMTP id 1so310381vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2011 11:08:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E96A696.9040607@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
 <1318445492-24207-23-git-send-email-arend@broadcom.com> <CAB=NE6XYFB4uWcRR1kSNKLaJC4W1E3uLZOd3hGEArjzsmNG4PQ@mail.gmail.com>
 <4E96A696.9040607@broadcom.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 13 Oct 2011 11:08:15 -0700
Message-ID: <CAB=NE6XiXc=TsjQ0bCphqaprDAjrXMfoKaQTwyNu-hX2d0issA@mail.gmail.com> (sfid-20111013_200839_410471_97C476DE)
Subject: Re: [PATCH 22/22] brcm80211: removed file wifi.c
To: Arend van Spriel <arend@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Alwin Beukers <alwin@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 13, 2011 at 1:51 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 10/12/2011 11:54 PM, Luis R. Rodriguez wrote:
>> On Wed, Oct 12, 2011 at 11:51 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>> From: Alwin Beukers <alwin@broadcom.com>
>>>
>>> Wifi.c was empty after previous cleanups, so it was removed.
>>>
>>> Reviewed-by: Arend van Spriel <arend@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>
>> Heh, remove Reviewed-by dude.
>>
>>   Luis
>>
>
> I had a remark on this in earlier commits. So I am clearly missing the
> point here. The author submitted this change and others for review to me
> and I reviewed it as requested. Hence the Reviewed-by: entry.
>
> I have been given the task to publish these patches and I sign them off
> for the "Developer's Certificate of Origin". Hence the Signed-off-by: entry.
>
> Is there something wrong with this reasoning?

Yeah this all makes no sense. If someone submits you a patch for you
to review *and* push upstream you simply add *their* SOB first, and
then after that your own.

  Luis
