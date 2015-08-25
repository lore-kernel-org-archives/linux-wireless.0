Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:58266 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbHYQmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 12:42:31 -0400
Message-ID: <55DC9AF0.3040304@broadcom.com> (sfid-20150825_184235_043499_FFBDBC4C)
Date: Tue, 25 Aug 2015 18:42:24 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3 0/6] brcmfmac: nvram loading and code rework
References: <1440101168-2252-1-git-send-email-arend@broadcom.com> <CACna6ryBL+bpBM4TekcNCotou-gey=k6_aYJVT+F-Sm0V0fuiw@mail.gmail.com>
In-Reply-To: <CACna6ryBL+bpBM4TekcNCotou-gey=k6_aYJVT+F-Sm0V0fuiw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/25/2015 06:09 PM, Rafał Miłecki wrote:
> On 20 August 2015 at 22:06, Arend van Spriel <arend@broadcom.com> wrote:
>> This series comprises of following changes:
>> - support NVRAM loading for bcm47xx platform.
>> - revise announced interface combinations and validate against it.
>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>> - PCIe fix for handling queue overflow.
>> - support more firmware events (for bcm4339 firmware).
>>
>> The series is intended for v4.3 kernel and applies to the master branch
>> of the wireless-drivers-next repository. Removed patch from this series
>> that reportedly has issue on OpenWrt platform.
>
> I believe that V3 also got following patch dropped:
> brcmfmac: consolidate ifp lookup in driver core
> https://patchwork.kernel.org/patch/6767991/
>
> As we tracked regressing patch to be "brcmfmac: Increase nr of
> supported flowrings.", I believe you can safely re-submit above (ifp
> lookup) one. I tested it on top of wireless-drivers-next brcmfmac and
> it works fine (no regressions).

That patch was already dropped from V2 (if my memory is right). Let's 
not confuse our maintainer. I will resubmit that patch. Hopefully it 
will make it in 4.3. What is the deadline, Kalle.

Regards,
Arend

