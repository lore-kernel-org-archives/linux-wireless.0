Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33470 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855AbbHLBRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2015 21:17:07 -0400
Received: by oio137 with SMTP id 137so1484657oio.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2015 18:17:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAd53p7rskK4a=mX4Gxk+6MBjmPpuMWW50XiciBLiZoT0JfyKQ@mail.gmail.com>
References: <1438917073-5720-1-git-send-email-acelan.kao@canonical.com>
	<55C4DDF5.6010901@lwfinger.net>
	<CAFv23Qk285G47pPVrfUn5izfZyrc-vCSPqJamnoxQMm6Ae9zpQ@mail.gmail.com>
	<20150810041957.GA7681@us.netrek.org>
	<CAAd53p5Lwm-2qDh=hc8Kp8XYUafxksyQn9ouOjHW_PymPQ-i9w@mail.gmail.com>
	<20150810120154.GA22283@us.netrek.org>
	<CAAd53p7rskK4a=mX4Gxk+6MBjmPpuMWW50XiciBLiZoT0JfyKQ@mail.gmail.com>
Date: Wed, 12 Aug 2015 09:17:07 +0800
Message-ID: <CAFv23Qk-d182BinKR2NLCxBXgFCMvL7NyuqMY+iPgE8V2NH1vw@mail.gmail.com> (sfid-20150812_031712_285158_C5C9A91A)
Subject: Re: [PATCH] rtlwifi: rtl8723be: disable FW control power save
From: AceLan Kao <acelan.kao@canonical.com>
To: Kai Heng Feng <kai.heng.feng@canonical.com>
Cc: James Cameron <quozl@laptop.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have some new findings that doesn't need to modify the parameter.
I'm still testing the new driver and will submit the patch later.

Best regards,
AceLan Kao.

2015-08-11 9:45 GMT+08:00 Kai Heng Feng <kai.heng.feng@canonical.com>:
> Hi James,
>
> I think the newer firmware in conjunction with "fwlps=0"
> should work fine in my (limited) testing.
>
> Thanks,
> Kai-Heng Feng
>
>
> On Mon, Aug 10, 2015 at 8:01 PM, James Cameron <quozl@laptop.org> wrote:
>> On Mon, Aug 10, 2015 at 06:47:05PM +0800, Kai Heng Feng wrote:
>>> Do you use Ubuntu Trusty (14.04)?
>>
>> Yes, that's what I'm using.
>>
>>> The rtl8723be firmware is not up-to-date in Trusty's linux-firmware.
>>> You can grab the newer one from the upstream linux-firmware.
>>
>> Thanks, but both seem to work fine (apart from the issue in this
>> thread), and I don't have a list of what has changed.
>>
>> --
>> James Cameron
>> http://quozl.linux.org.au/
