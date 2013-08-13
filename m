Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4667 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758926Ab3HMUqx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:46:53 -0400
Message-ID: <520A9B0D.3050006@broadcom.com> (sfid-20130813_224657_287077_4048FCE5)
Date: Tue, 13 Aug 2013 22:46:05 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "David Herrmann" <dh.herrmann@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Jonas Gorski" <jogo@openwrt.org>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: Re: [RFT 00/13] brcmsmac: bcm4313 iPA related patches
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
 <CANq1E4TO8radaMFoLjiwhSq2JAFqcLm8UMQvaq9oJRHiWz=60w@mail.gmail.com>
In-Reply-To: <CANq1E4TO8radaMFoLjiwhSq2JAFqcLm8UMQvaq9oJRHiWz=60w@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2013 10:09 PM, David Herrmann wrote:
> Hi
>
> On Tue, Aug 13, 2013 at 10:03 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> This series replaces the patch "[PATCH 12/12] brcmsmac: support 4313iPA"
>> with Message-ID: <1376130450-29746-13-git-send-email-arend@broadcom.com>.
>>
>> It has been split up into individual patches. Please test this series
>> especially if you had issues with the original commit b6fc28a that was
>> reverted.
>>
>> Cc: Jonas Gorski <jogo@openwrt.org>
>> Cc: David Herrmann <dh.herrmann@gmail.com>
>> Cc: Maximilian Engelhardt <maxi@daemonizer.de>
>> Cc: David Costa <david@zarel.net>
>
> Is this available in a public branch that I can merge? And what should
> be used as base? 3.11-rc5? linux-next?

Indeed I should have mentioned. It applies on v3.11-rc5 for sure. Did 
not try linux-next.

Regards,
Arend

> Cheers
> David
>
>> Arend van Spriel (13):
>>    brcmsmac: cosmetic change in phy_lcn.c
>>    brcmsmac: change pa_gain for bcm4313 iPA
>>    brcmsmac: use ARRAY_SIZE in phytbl_lcn.c
>>    brcmsmac: add switch control table for BCM4313 iPA BT-combo cards
>>    brcmsmac: add debug info message providing phy and radio info
>>    brcmsmac: update transmit gain table for lcn phy
>>    brcmsmac: change lcnphy receive i/q calibration routine
>>    brcmsmac: fix TSSI idle estimation
>>    brcmsmac: avoid calling set_txpwr_by_index() twice
>>    brcmsmac: rework switch control table init including iPA BT-combo
>>    brcmsmac: correct phy registers for TSSI-based power control
>>    brcmsmac: reinitialize TSSI power control upon channel switch
>>    brcmsmac: add support for BCM4313 iPA variant
>>
>>   drivers/net/wireless/brcm80211/brcmsmac/main.c     |    4 +-
>>   .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  397 +++++++++++--------
>>   .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |  405 +++++++++++---------
>>   .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h   |    1 +
>>   4 files changed, 475 insertions(+), 332 deletions(-)
>>
>> --
>> 1.7.10.4
>>
>>
>


