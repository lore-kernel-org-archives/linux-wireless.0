Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46692 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab0FLRg7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 13:36:59 -0400
Message-ID: <4C13C5B5.3080609@openwrt.org>
Date: Sat, 12 Jun 2010 19:36:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	linville@tuxdriver.com
Subject: Re: [PATCH 4/7] ath9k_hw: remove ATH9K_CAP_TKIP_SPLIT
References: <1276356154-66545-1-git-send-email-nbd@openwrt.org>	 <1276356154-66545-2-git-send-email-nbd@openwrt.org>	 <1276356154-66545-3-git-send-email-nbd@openwrt.org>	 <1276356154-66545-4-git-send-email-nbd@openwrt.org> <1276363723.2625.7.camel@ct>
In-Reply-To: <1276363723.2625.7.camel@ct>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-12 7:28 PM, Pavel Roskin wrote:
> On Sat, 2010-06-12 at 17:22 +0200, Felix Fietkau wrote:
>> This is only used as a workaround for an issue in one specific hw revision.
> 
> Is that workaround needed for both PCI and USB?  If not,
> common->splitmic should not be needed and further cleanup should be
> possible.
It's only needed for PCI.

- Felix
