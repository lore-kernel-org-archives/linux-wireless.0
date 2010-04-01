Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f199.google.com ([209.85.223.199]:59133 "EHLO
	mail-iw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0DAXMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 19:12:47 -0400
Received: by iwn37 with SMTP id 37so1119540iwn.15
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 16:12:46 -0700 (PDT)
Message-ID: <4BB52867.4080304@lwfinger.net>
Date: Thu, 01 Apr 2010 18:12:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "richardvoigt@gmail.com" <richardvoigt@gmail.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Myhailo Danylenko <isbear@ukrpost.net>
Subject: Re: [PATCH] b43: N-PHY: fix copy&paste typo
References: <1270156270-7550-2-git-send-email-zajec5@gmail.com> <m2y2e59e6971004011605oc44de860q87948992252fbac2@mail.gmail.com>
In-Reply-To: <m2y2e59e6971004011605oc44de860q87948992252fbac2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/01/2010 06:05 PM, richardvoigt@gmail.com wrote:
> Does anybody else think all the magic numbers make this code hard to understand?
> 
> 2010/4/1 Rafał Miłecki <zajec5@gmail.com>:
>> Reported-by: Myhailo Danylenko <isbear@ukrpost.net>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/phy_n.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
>> index 6fd140a..2ae2445 100644
>> --- a/drivers/net/wireless/b43/phy_n.c
>> +++ b/drivers/net/wireless/b43/phy_n.c
>> @@ -2790,7 +2790,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
>>                        }
>>                        b43_ntab_write_bulk(dev, B43_NTAB16(15, 88), 4,

If you have any idea what the 16-bit N PHY table 15 with offset 88 and
length 4 means to the firmware, please be our guest. All those us that
do the RE can only decompile the Broadcom driver, and write the specs.
Rafal writes the b43 code from that.

Larry

