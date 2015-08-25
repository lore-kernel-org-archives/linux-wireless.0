Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39143 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbbHYQxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 12:53:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3 0/6] brcmfmac: nvram loading and code rework
References: <1440101168-2252-1-git-send-email-arend@broadcom.com>
	<CACna6ryBL+bpBM4TekcNCotou-gey=k6_aYJVT+F-Sm0V0fuiw@mail.gmail.com>
	<55DC9AF0.3040304@broadcom.com>
Date: Tue, 25 Aug 2015 19:53:26 +0300
In-Reply-To: <55DC9AF0.3040304@broadcom.com> (Arend van Spriel's message of
	"Tue, 25 Aug 2015 18:42:24 +0200")
Message-ID: <87h9nn48e1.fsf@kamboji.qca.qualcomm.com> (sfid-20150825_185337_837764_7D3E2C8D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 08/25/2015 06:09 PM, Rafał Miłecki wrote:
>> On 20 August 2015 at 22:06, Arend van Spriel <arend@broadcom.com> wrote:
>>> This series comprises of following changes:
>>> - support NVRAM loading for bcm47xx platform.
>>> - revise announced interface combinations and validate against it.
>>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>>> - PCIe fix for handling queue overflow.
>>> - support more firmware events (for bcm4339 firmware).
>>>
>>> The series is intended for v4.3 kernel and applies to the master branch
>>> of the wireless-drivers-next repository. Removed patch from this series
>>> that reportedly has issue on OpenWrt platform.
>>
>> I believe that V3 also got following patch dropped:
>> brcmfmac: consolidate ifp lookup in driver core
>> https://patchwork.kernel.org/patch/6767991/
>>
>> As we tracked regressing patch to be "brcmfmac: Increase nr of
>> supported flowrings.", I believe you can safely re-submit above (ifp
>> lookup) one. I tested it on top of wireless-drivers-next brcmfmac and
>> it works fine (no regressions).
>
> That patch was already dropped from V2 (if my memory is right). Let's
> not confuse our maintainer. I will resubmit that patch. Hopefully it
> will make it in 4.3. What is the deadline, Kalle.

Now :) And even when I can't promise anything...

-- 
Kalle Valo
