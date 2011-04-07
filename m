Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exprod7og119.obsmtp.com ([64.18.2.16]:55631 "EHLO
	exprod7og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab1DGXKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 19:10:51 -0400
Received: by pxi16 with SMTP id 16so1597752pxi.4
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 16:10:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <73768.20361.qm@web161614.mail.bf1.yahoo.com>
References: <4D9E316E.4000908@lwfinger.net>
	<73768.20361.qm@web161614.mail.bf1.yahoo.com>
Date: Thu, 7 Apr 2011 18:03:27 -0500
Message-ID: <BANLkTikRMATHAUmsQa8T4LD4_C9T76asAQ@mail.gmail.com>
Subject: Re: Questions about rt2800usb
From: Steev Klimaszewski <steev@genesi-usa.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: Jett Chen <jett_chen@ralinktech.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 7, 2011 at 5:19 PM, Walter Goldens <goldenstranger@yahoo.com> wrote:
>
>> I know from experience that the
>> staging driver rt82860sta has been replaced by rt2800pci and
>> I plan to push a patch deleting the driver from staging.
>>
>> It appears that rt2870sta has been replaced by rt2800usb.
>> Is that correct? If so, I will also include the deletion of
>> that driver from staging in the patch.
>>
>> I noticed that rt2870sta includes a few USB IDs not found
>> in rt2800usb, namely:
>>
>> 0x2001:0x3c09, 0x2001:0x3c0a, and 0x2019:0xed14.
>>
>> Any reasons why these should not be included in rt2800usb?
>>
>> Please let me know of any objections to removing those two
>> staging drivers.
>
> Here's my vote against removing the rt2870sta from staging. Some longstanding issues with latency and duplicate packets (rt307x) are persistent with rt2800usb, whereas rt2870sta works fine.
>
> my two cents
>
> Walter

Personally, I've had the opposite (since the patch to disable power
management on rt2800usb.)  rt2870sta hasn't been noticeably more
stable, and in fact, I tend to see div0 bugs quite often when using
it.  That said, I'm using Azurewave rt3070s.

-- 
Steev Klimaszewski <steev@genesi-usa.com>
Senior Software Engineer, Genesi USA, Inc.
