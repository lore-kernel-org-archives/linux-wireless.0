Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server11.hostfactory.ch ([62.146.13.133]:48104 "EHLO
	server11.hostfactory.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934322AbbGVQiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 12:38:05 -0400
Message-ID: <55AFC6E1.7060706@weiss.ch> (sfid-20150722_183812_982601_8E5CC0B4)
Date: Wed, 22 Jul 2015 18:37:53 +0200
From: Rolf Anderegg <rolf.anderegg@weiss.ch>
Reply-To: rolf.anderegg@weiss.ch
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc: virtual interfaces, AP connection drop & kernel warning
References: <559D41B3.4050604@weiss.ch> <559F9AF8.5000208@rempel-privat.de> <55A3A672.1060502@weiss.ch> <55A79B5C.7010501@rempel-privat.de>
In-Reply-To: <55A79B5C.7010501@rempel-privat.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 16/07/15 13:54, Oleksij Rempel wrote:
> Am 13.07.2015 um 13:52 schrieb Rolf Anderegg:
>>
>> I suspect that there are bandwidth/speed issues when dealing with USB
>> adapters, but that does not inherently mean that the connection is prone
>> to drop, right? Doesn't that mean that I am leaking packages somewhere
>> along the way? What else could I be looking for?
> 
> The packages can drop if you will do channel scan. STA mode need some
> seconds to complete channel scan. It means AP will be all the time
> unavailable.

Ok, that may be. Then again why am I not experiencing the same
connection drop on my ath5k setup? Because the channel scan is more
likely to be completed in due time?

Regards,
Rolf Anderegg
