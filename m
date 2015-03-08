Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:43970 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbbCHLGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 07:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <36252734.kTKJHJAt2s@wuerfel>
References: <1424362401-8228-1-git-send-email-eliad@wizery.com>
	<36252734.kTKJHJAt2s@wuerfel>
Date: Sun, 8 Mar 2015 13:06:00 +0200
Message-ID: <CAB3XZEcPvTpfviwyY5WpPGWYinGk8qq2yWEKm95n1j7LNDQ_CA@mail.gmail.com> (sfid-20150308_120605_869514_1E3DC814)
Subject: Re: [PATCH v3 1/2] dt: bindings: add wl18xx wireless device
From: Eliad Peller <eliad@wizery.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 27, 2015 at 10:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 19 February 2015 18:13:20 Eliad Peller wrote:
>> +Required properties:
>> + - compatible : Should be "ti,wl18xx".
>
> Do not use wildcards in the compatible string, use specific model numbers.

ok. i'll change it to ti,wl1835 and ti,wl1837

thanks,
Eliad.
