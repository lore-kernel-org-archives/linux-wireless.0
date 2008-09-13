Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:37496 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYIMNEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 09:04:34 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1225366wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 13 Sep 2008 06:04:33 -0700 (PDT)
Message-ID: <69e28c910809130604nb23b212vadddbcf571a13020@mail.gmail.com> (sfid-20080913_150449_290323_CC5D7732)
Date: Sat, 13 Sep 2008 15:04:33 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Mike Cui" <cuicui@gmail.com>
Subject: Re: BMC4310 support (03f0:171d)
Cc: "Nadav Kavalerchik" <nadavkav@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <7c8826910809122011i23587a6bta838f2e0a7c39744@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4219988b0809011331j4acb1582u3239218c6b7ff573@mail.gmail.com>
	 <4219988b0809011349i640d36e0p497eb8cefe303d0@mail.gmail.com>
	 <200809012333.58897.mb@bu3sch.de>
	 <4219988b0809091240s970c580k763054a56ef740b3@mail.gmail.com>
	 <4219988b0809091241l565fa8fcpebe2fb552782c4d4@mail.gmail.com>
	 <7c8826910809120133o13c744d0pbfae5a18dd72787f@mail.gmail.com>
	 <69e28c910809121157qaaad7c8w67d626e60e807892@mail.gmail.com>
	 <7c8826910809122011i23587a6bta838f2e0a7c39744@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 13, 2008 at 5:11 AM, Mike Cui <cuicui@gmail.com> wrote:
>> It is not a "BCM4315", it is a BCM4310. There is no such thing as a
>> BCM4315. Chip ID != PCI ID!
>> Most chip IDs match with their respective PCI IDs, but here are some exceptions:
>> 0x4320 is BCM4306.
>> 0x4315 is BCM4310.
>> 0x4328 is BCM4321.
>> 0x432b is BCM4322.
>
> Maybe...
>
> But on the miniPCIe chip itself, there is a sticker that says Broadcom
> 4312. But it's not a BCM4312 either, because BCM4312 actually works...
>

Maybe we should refine the list a bit then, as follows:
0x4320 is BCM4306
0x4311 is BCM4311BG (colloquially "BCM4311")
0x4312 is BCM4311ABG (colloquially "BCM4312")
0x4315 is BCM4312 (colloquially "BCM4310")
0x4318 can be both BCM4318 and BCM4318E
0x4328 is BCM4321 (colloquially "BCM4328")
0x432b is BCM4322

In that case, is "BCM4309" actually BCM4306ABG?
-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
