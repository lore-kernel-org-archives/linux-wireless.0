Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:46784 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab1C3CzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 22:55:25 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2U2tHoJ013622
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 22:55:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 89EEB1E05FB
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 22:55:16 -0400 (EDT)
Message-ID: <4D929B98.7050207@lockie.ca>
Date: Tue, 29 Mar 2011 22:55:20 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: regdomain
References: <4D91697C.2050603@lockie.ca> <AANLkTikUfjM1eDprL_YDFuasVvTdpRoAzKXStJf-5C7e@mail.gmail.com> <4D923FC3.3010309@lockie.ca> <AANLkTimbxYgtSH9t75s9QCSb892QR1yBoOJUPToDCyCV@mail.gmail.com>
In-Reply-To: <AANLkTimbxYgtSH9t75s9QCSb892QR1yBoOJUPToDCyCV@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/11 16:48, Luis R. Rodriguez wrote:

>> I am trying to debug this card since it works on kernel-2.6.36.2 but not
>> any later one.
> Define "works" and "not works". You can bisect if you know two kernel
> releases that you can use a bisection points, a good one and a bad
> one. Please review how to do that.
>
>   Luis
It misses a lot of SSIDs during a scan (different ones each time) and it
won't associate with an open AP.
I suspected a hardware problem but it works fine on kernel-2.6.36.2.
I'lll google how to bisect.

