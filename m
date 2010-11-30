Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39896 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab0K3SrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 13:47:00 -0500
Message-ID: <4CF546A1.1060904@openwrt.org>
Date: Tue, 30 Nov 2010 19:46:57 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH 2.6.37 v2 1/2] ath9k_hw: fix endian issues with CTLs on
 AR9003
References: <1291131338-93870-1-git-send-email-nbd@openwrt.org> <20101130182715.GD2341@tuxdriver.com>
In-Reply-To: <20101130182715.GD2341@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-30 7:27 PM, John W. Linville wrote:
> On Tue, Nov 30, 2010 at 04:35:37PM +0100, Felix Fietkau wrote:
>> Parsing data using bitfields is messy, because it makes endian handling
>> much harder. AR9002 and earlier got it right, AR9003 got it wrong.
>> This might lead to either using too high or too low tx power values,
>> depending on frequency and eeprom settings.
>> Fix it by getting rid of the CTL related bitfields entirely and use
>> masks instead.
Oh, sorry, sent it from the wrong tree. Will resend...
