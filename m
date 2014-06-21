Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24522 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaFUQs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 12:48:59 -0400
Message-ID: <53A5B778.907@broadcom.com> (sfid-20140621_184906_970017_D72A1603)
Date: Sat, 21 Jun 2014 18:48:56 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/8] brcmfmac: new USB devices, vendor command, and cleanup
References: <1403345479-13467-1-git-send-email-arend@broadcom.com> <CACna6ryu6b=d9hpi71czo1q6uiWDZ4u+hXO-omAg6g23Y68xug@mail.gmail.com>
In-Reply-To: <CACna6ryu6b=d9hpi71czo1q6uiWDZ4u+hXO-omAg6g23Y68xug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/14 17:58, Rafał Miłecki wrote:
> On 21 June 2014 12:11, Arend van Spriel<arend@broadcom.com>  wrote:
>> The patch series add driver support for new USB device. These are 11ac fullmac
>> devices with USB3.0 interface. Also opting for the vendor-specific netlink
>> command instead of cfg80211 testmode. The remaining patches are small cleanup
>> patches.
>>
>> This series is intended for 3.17 and applies to the master branch of the
>> wireless-next repository.
>
> I've slightly updated
> http://wireless.kernel.org/en/users/Drivers/brcm80211
> , feel free to correct me if I did anything wrong.

Slightly thanks ;-) I got the notification emails and it looks fine.

Regards,
Arend
