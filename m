Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46238 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1CYNmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 09:42:35 -0400
Received: by fxm17 with SMTP id 17so1153740fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2011 06:42:34 -0700 (PDT)
Message-ID: <4D8C9BC7.3090204@googlemail.com>
Date: Fri, 25 Mar 2011 14:42:31 +0100
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Disabling ACKs with ath5k
References: <4D8C4764.7060107@googlemail.com> <20110325131957.GA2242@tuxdriver.com>
In-Reply-To: <20110325131957.GA2242@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello John,

the goal would be to have a transmission as fast as possible while
ignoring, if a packet reached its destination or not. I'd like to test
wireless performance regarding transmission time in a dedicated
environment. As far as I can see, backoff might already push the
transmission times up quite a lot and if I'd even add the time of -
worst case - 10 retransmissions, the transmission time of one packet
will grow even more.

It would be second-rank, if the packet reaches its destination. Loss of
some packets is not a problem in my testbed.

So I'd like to disable usage of ACKs in order to be off with the only
problem - backoff. Disabling this would of course be nice, but I fear,
that's far more work that just disabling ACKs.

Dennis

John W. Linville schrieb:
> On Fri, Mar 25, 2011 at 08:42:28AM +0100, Dennis Borgmann wrote:
>
>   
>> Is there an interface to disable transmission of ACKs and on the other
>> hand ignoring unreceived ACKs. It can be done with multicasting, but can
>> it also be achieved by a setting with non-multicast-traffic? I am using
>> ath5k.
>>     
>
> I'm curious, why do you want to do that?
>
>   

