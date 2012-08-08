Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36940 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab2HHOXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 10:23:30 -0400
Message-ID: <50227660.305@openwrt.org> (sfid-20120808_162333_587804_11FBAAB0)
Date: Wed, 08 Aug 2012 16:23:28 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.6 4/4] ath9k_hw: enable PA linearization
References: <1344344772-49459-1-git-send-email-nbd@openwrt.org> <1344344772-49459-2-git-send-email-nbd@openwrt.org> <1344344772-49459-3-git-send-email-nbd@openwrt.org> <1344344772-49459-4-git-send-email-nbd@openwrt.org> <CAD2nsn3wMOpVSJ+_man8cNwVF-jGAX6r1cWsx+H_TpQjzyKzKg@mail.gmail.com>
In-Reply-To: <CAD2nsn3wMOpVSJ+_man8cNwVF-jGAX6r1cWsx+H_TpQjzyKzKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-08 4:17 PM, Mohammed Shafi wrote:
> Hi Felix!
> 
> On Tue, Aug 7, 2012 at 6:36 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> This feature had been disabled in ath9k because the code to support
>> it was incomplete, but now the code is in sync with the internal QCA
>> codebase, so it's time to enable it.
> 
> is it enabled for all AR9300 based chipsets ?
All AR93xx based devices where it is marked as supported in EEPROM.

- Felix
