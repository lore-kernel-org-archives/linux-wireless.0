Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57091 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030676Ab0B0TJr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 14:09:47 -0500
Message-ID: <4B896DF5.4050306@openwrt.org>
Date: Sat, 27 Feb 2010 20:09:41 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC] ath9k: Make AR_SREV_5416() macro evaluate to true for
 AR9100
References: <133e8d7e1002270926p64cfd2b5uc4017bf0187c53c2@mail.gmail.com>	 <4B895AAA.6070700@openwrt.org> <133e8d7e1002271054s71138b5csb10d5ea2f4488231@mail.gmail.com>
In-Reply-To: <133e8d7e1002271054s71138b5csb10d5ea2f4488231@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-02-27 7:54 PM, Björn Smedman wrote:
> Oops, I got those parenthesis mixed up. You are right. My bad.
> 
> But is AR9100 really not AR5416 based? For instance the devid define
> is named AR5416_AR9100_DEVID and the original firmware reports the
> chipset as
> 
>   ath_hal: 0.9.17.1 (AR5416, DEBUG, REGOPS_FUNC, WRITE_EEPROM, 11D)
> 
> Confusing, but you are probably right.
Let's say it's 'loosely' based on AR5416. There are three currently
available chip generations of the 11n stuff: 5416, 9160, 9280.
The WiSoC stuff (named 9100, but it's typically 913x) belongs to 9160.

- Felix
