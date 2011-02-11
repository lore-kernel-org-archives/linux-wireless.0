Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35903 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab1BKQVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 11:21:09 -0500
Message-ID: <4D5561F2.3050404@openwrt.org>
Date: Fri, 11 Feb 2011 17:21:06 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k: make use of slot time macros
References: <1297407704-4029-1-git-send-email-mshajakhan@atheros.com> <4D553107.3020402@openwrt.org> <20110211161551.GA2224@tuxdriver.com>
In-Reply-To: <20110211161551.GA2224@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-11 5:15 PM, John W. Linville wrote:
> On Fri, Feb 11, 2011 at 01:52:23PM +0100, Felix Fietkau wrote:
>> On 2011-02-11 8:01 AM, Mohammed Shafi Shajakhan wrote:
>> > From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>> > 
>> > Instead of using raw numbers to assign slot time it would be better to
>> > make use of predefined slot time macros
>> How does this make it better?
> 
> Maybe if it was ATH9K_SHORT_SLOT_TIME it would make more sense?
Well, neither the unit of this variable, nor the values that can be used
are ath9k specific.

- Felix
