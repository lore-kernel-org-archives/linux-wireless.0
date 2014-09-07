Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:39427 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaIGITY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2014 04:19:24 -0400
Received: by mail-lb0-f179.google.com with SMTP id p9so2823864lbv.10
        for <linux-wireless@vger.kernel.org>; Sun, 07 Sep 2014 01:19:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140902153035.GG15412@merlin.infradead.org>
References: <54057C59.4020807@gmail.com>
	<20140902153035.GG15412@merlin.infradead.org>
Date: Sun, 7 Sep 2014 11:19:22 +0300
Message-ID: <CANUX_P1gZ22Ge2pLKtb=1-3831yTRC2KmisZ59gzJk=MDw0JYA@mail.gmail.com> (sfid-20140907_101940_044926_77A6EE08)
Subject: Re: pull request: new firmware for 7260 / 7265 / 3160: 25.222.9.0
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-firmware@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach
egrumbach@gmail.com


On Tue, Sep 2, 2014 at 6:30 PM, Kyle McMartin <kyle@infradead.org> wrote:
> On Tue, Sep 02, 2014 at 11:14:17AM +0300, Emmanuel Grumbach wrote:
>> Dear linux-firmware.git maintainers,
>>
>> Intel released a new -9 firmware for its WiFi adpaters for the 7000 family.
>> No new features here, but only bug fixes.
>>
>> The following changes since commit e2844339cb779c00f856c554958e16beca99b462:
>>
>>   iwlwifi: update firmware for 3160 / 7260 / 7265 (2014-05-19 14:45:28 +0300)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware.git master
>>
>> for you to fetch changes up to e302d06fb8cd3ceade38ce484636094b1cd25a23:
>>
>>   iwlwifi: update firmware for 3160 / 7260 / 7265 (2014-09-02 11:06:42 +0300)
>>
>> ----------------------------------------------------------------
>> Emmanuel Grumbach (1):
>>       iwlwifi: update firmware for 3160 / 7260 / 7265
>>
>>  WHENCE               |   6 +++---
>>  iwlwifi-3160-9.ucode | Bin 666792 -> 669156 bytes
>>  iwlwifi-7260-9.ucode | Bin 679380 -> 681464 bytes
>>  iwlwifi-7265-9.ucode | Bin 691960 -> 697012 bytes
>>  4 files changed, 3 insertions(+), 3 deletions(-)
>>
>
> thanks, i'll get to this today.

I couldn't find the new firmware in linux-firmware.git, am I missing something?
