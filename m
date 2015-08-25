Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48031 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbbHYMgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 08:36:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3 0/6] brcmfmac: nvram loading and code rework
References: <1440101168-2252-1-git-send-email-arend@broadcom.com>
	<CACna6rxtHaj-czX6z28UL8LL5VAyxVrEgimn5fVz8NpU5DOwgw@mail.gmail.com>
	<55D64555.2090207@broadcom.com>
Date: Tue, 25 Aug 2015 15:36:39 +0300
In-Reply-To: <55D64555.2090207@broadcom.com> (Arend van Spriel's message of
	"Thu, 20 Aug 2015 23:23:33 +0200")
Message-ID: <87egir5yug.fsf@kamboji.qca.qualcomm.com> (sfid-20150825_143648_288076_653CA657)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 08/20/2015 11:20 PM, Rafał Miłecki wrote:
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
>> Tested-by: Rafał Miłecki <zajec5@gmail.com>
>>
>> No regression with this version, getting platform NVRAM works.
>
> Thanks, Rafał
>
> Kalle,
>
> Will you add the "Tested-by:" or should I?

To save time I normally try avoid adding those myself, but what one can
do is to reply to the patch (not to the cover letter) with the
"Tested-by" line. Patchwork should when automatically add that when I
apply the patch.

At least Acked-by works like this, I would assume it's the same with
Tested-by as well. Does anyone know?

-- 
Kalle Valo
