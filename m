Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38749 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab0KVVHB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 16:07:01 -0500
Message-ID: <4CEADB73.1050205@openwrt.org>
Date: Mon, 22 Nov 2010 22:06:59 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k_hw: fix more bitfield related endian issues
References: <1290280970-37519-1-git-send-email-nbd@openwrt.org> <20101122201541.GH2117@tuxdriver.com>
In-Reply-To: <20101122201541.GH2117@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-22 9:15 PM, John W. Linville wrote:
> On Sat, Nov 20, 2010 at 08:22:50PM +0100, Felix Fietkau wrote:
>> A few LNA control related flags were also specified as a bitfields, however
>> for some strange reason they were written in big-endian order this time.
>> Fix this by using flags instead.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Cc: stable@kenrel.org
Oops.

> Why does this merit stable@kernel.org (misspelled, BTW) inclusion?
Trivial bug that can easily mess up baseband settings in some cases. Not
sure if it could also mess with tx power.

- Felix
