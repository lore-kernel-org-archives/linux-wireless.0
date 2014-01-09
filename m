Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:31630 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaAIJfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 04:35:38 -0500
Message-ID: <52CE6D66.1020707@broadcom.com> (sfid-20140109_103544_497863_E1FFCD42)
Date: Thu, 9 Jan 2014 10:35:34 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Naughtboy <skylvlinux@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: have any others tools to test the wifi moduels throughput ???
References: <CAKH5=LuBkCSf5nLYTzivDJj_sdZ4GZRxDy0_sr7-TxkKm0Rq5A@mail.gmail.com>
In-Reply-To: <CAKH5=LuBkCSf5nLYTzivDJj_sdZ4GZRxDy0_sr7-TxkKm0Rq5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2014 08:52 AM, Naughtboy wrote:
> hi big guys!
> i have some problem is test the wifi moduels  throughput
> just the tools i kown is iperf ,and it performance just ok


Not sure what problem you are having. What I read in your text: You used
iperf and performance is fine so you want to use another tool? huh?

> and here  have any others tools to test the wifi moduels  throughput ???

I guess you are looking for free open-source tools? I mostly use iperf.
There is an iperf3 [1] which has some additional features (eg. QoS).
Commercial one that I used in the past is chariot from ixia [2].

Gr. AvS

[1] https://code.google.com/p/iperf/
[2] http://www.ixiacom.com/products/ixchariot/

> if you kown it
> please do me a handle ,
> thank adavnce!!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

