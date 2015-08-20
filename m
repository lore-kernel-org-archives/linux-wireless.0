Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6178 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbbHTVXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 17:23:36 -0400
Message-ID: <55D64555.2090207@broadcom.com> (sfid-20150820_232339_810681_6DC97659)
Date: Thu, 20 Aug 2015 23:23:33 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3 0/6] brcmfmac: nvram loading and code rework
References: <1440101168-2252-1-git-send-email-arend@broadcom.com> <CACna6rxtHaj-czX6z28UL8LL5VAyxVrEgimn5fVz8NpU5DOwgw@mail.gmail.com>
In-Reply-To: <CACna6rxtHaj-czX6z28UL8LL5VAyxVrEgimn5fVz8NpU5DOwgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2015 11:20 PM, Rafał Miłecki wrote:
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
> Tested-by: Rafał Miłecki <zajec5@gmail.com>
>
> No regression with this version, getting platform NVRAM works.

Thanks, Rafał

Kalle,

Will you add the "Tested-by:" or should I?

Regards,
Arend

