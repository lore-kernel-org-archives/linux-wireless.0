Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.cs.drexel.edu ([129.25.8.238]:52573 "EHLO
	mail.cs.drexel.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab1CSJAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 05:00:07 -0400
Message-ID: <4D847091.4010408@cs.drexel.edu>
Date: Sat, 19 Mar 2011 05:00:01 -0400
From: Lee Trager <lt73@cs.drexel.edu>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath3k: Add ASUS BT Support
References: <4D831ACF.5030506@cs.drexel.edu> <AANLkTimwAb8cEEyZSNUgwxZS2deOLv_ZWa1HOi9cnJTL@mail.gmail.com> <AANLkTimiTViSeaJFCKM9sz3wHaA74RLMgVXNRMKQp1PL@mail.gmail.com>
In-Reply-To: <AANLkTimiTViSeaJFCKM9sz3wHaA74RLMgVXNRMKQp1PL@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, thanks. I just posted here because the Linux-wireless web page has a
page on this driver, I thought it was odd but submitted here anyway.

Lee

On 03/18/11 05:01, Luis R. Rodriguez wrote:
> On Fri, Mar 18, 2011 at 2:00 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Fri, Mar 18, 2011 at 1:41 AM, Lee Trager <lt73@cs.drexel.edu> wrote:
>>> The ASUS USB Bluetooth module that comes with my motherboard(ASUS P8P67
>>> Pro) is simply a re-branded Atheros AR3011. This patch add support for
>>> it in the driver
>>>
>>> Signed-off-by: Lee Trager <lt73@cs.drexel.edu>
>>
>> Please resubmit with Cc: stable@kernel.org on the commit log entry
>> (not the e-mail)
> 
> Also you want this to go through the BT maintainer, and Cc linux-bluetooth.
> 
> BLUETOOTH DRIVERS
> M:      Marcel Holtmann <marcel@holtmann.org>
> M:      Gustavo F. Padovan <padovan@profusion.mobi>
> L:      linux-bluetooth@vger.kernel.org
> W:      http://www.bluez.org/
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
> S:      Maintained
> F:      drivers/bluetooth/
> 
>   Luis

