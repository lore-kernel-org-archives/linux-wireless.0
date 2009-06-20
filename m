Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:44105 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZFTCYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 22:24:50 -0400
Received: by an-out-0708.google.com with SMTP id d40so3443550and.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 19:24:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A3C4745.7000706@gmail.com>
References: <4A3C2036.6060506@gmail.com> <43e72e890906191642kbcca090we1b03db19bf0e2c8@mail.gmail.com>
	<4A3C4593.6050707@gmail.com> <43e72e890906191915g2c9736f2i4633c8ed3766fe3b@mail.gmail.com>
	<4A3C4745.7000706@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 19 Jun 2009 19:24:33 -0700
Message-ID: <43e72e890906191924m2f83815fp860c0a277e44d2e1@mail.gmail.com>
Subject: Re: iwl3945 not working after recent commits
To: Darren Blaber <dmbtech@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 7:19 PM, Darren Blaber<dmbtech@gmail.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> On Fri, Jun 19, 2009 at 7:12 PM, Darren Blaber<dmbtech@gmail.com> wrote:
>>
>>>
>>> Luis R. Rodriguez wrote:
>>>
>>>>
>>>> On Fri, Jun 19, 2009 at 4:33 PM, Darren Blaber<dmbtech@gmail.com> wrote:
>>>>
>>>>
>>>>>
>>>>> Not sure which commit broke it, but using latest compat-wireless, I get
>>>>> this:
>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>>>
>>>>> Jun 17 19:17:11 pi kernel: [330532.746391] iwl3945 0000:0c:00.0: Failed
>>>>> to
>>>>> register hw (error -17)
>>>>>
>>>>>
>>>>
>>>> Try now, I just updated the tarball with John's latest applied patches
>>>> on wireless-testing.
>>>>
>>>> v2.6.30-26871-g25e4fbe
>>>> wireless-testing latest tag:
>>>> master-2009-06-19
>>>> This is compat-release:
>>>> master-2009-06-15-2-ged8e599
>>>>
>>>>  Luis
>>>>
>>>>
>>>
>>> Nope, I still receive
>>> [168936.466609] iwl3945 0000:0c:00.0: Tunable channels: 11 802.11bg, 13
>>> 802.11a channels
>>> [168936.466613] iwl3945 0000:0c:00.0: Detected Intel Wireless WiFi Link
>>> 3945ABG
>>> [168936.466789] iwl3945 0000:0c:00.0: irq 28 for MSI/MSI-X
>>> [168936.467229] iwl3945 0000:0c:00.0: Failed to register hw (error -17)
>>> [168936.467366] iwl3945 0000:0c:00.0: PCI INT A disabled
>>> [168936.467375] iwl3945: probe of 0000:0c:00.0 failed with error -17
>>>
>>
>> Hm, what kernel are you on? You can try wireless-testing directly.
>>
>> http://wireless.kernel.org/en/developers/Documentation/git-guide
>>
>>  Luis
>>
>
> I'm using 2.6.30 with the KMS radeon patches, don't know if that is
> interfering. I'll try wireless-testing directly.

Yeah this is odd, 2.6.30 shouldn't have an issue with backport unless
I'm missing something. Let us know how it goes with wireless-testing.

 Luis
