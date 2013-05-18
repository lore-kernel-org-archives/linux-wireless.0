Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out21.sjc.mx.trendmicro.com ([216.99.131.78]:49167 "EHLO
	out21.sjc.mx.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207Ab3ERRBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 13:01:16 -0400
Received: from out14.sjc.mx.trendmicro.com (unknown [216.99.131.51])
	by out21.sjc.mx.trendmicro.com (Postfix) with ESMTP id 1D2489CBBBE
	for <linux-wireless@vger.kernel.org>; Sat, 18 May 2013 16:43:31 +0000 (UTC)
Received: from relay07.sjc.mx.trendmicro.com (unknown [10.30.239.5])
	by out14.sjc.mx.trendmicro.com (Postfix) with ESMTP id A0E5E98042E
	for <linux-wireless@vger.kernel.org>; Sat, 18 May 2013 16:42:25 +0000 (UTC)
Received: from thinktube.com (unknown [111.68.225.247])
	by relay07.sjc.mx.trendmicro.com (Postfix) with ESMTP id 1A45B980415
	for <linux-wireless@vger.kernel.org>; Sat, 18 May 2013 16:42:24 +0000 (UTC)
Message-ID: <5197AF6B.5040800@thinktube.com> (sfid-20130518_190122_241212_A12163C5)
Date: Sat, 18 May 2013 17:42:19 +0100
From: Bruno Randolf <br1@thinktube.com>
MIME-Version: 1.0
To: Alessandro Lannocca <alessandro.lannocca@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rt3070-based usb device won't accept mac address changes
References: <CAMfPB_xTUy72YokSoYJezOX_gb54CJEd7V6+4pAfOHnAzUMJcQ@mail.gmail.com>
In-Reply-To: <CAMfPB_xTUy72YokSoYJezOX_gb54CJEd7V6+4pAfOHnAzUMJcQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/2013 04:10 PM, Alessandro Lannocca wrote:
> Hi, after switching to kernel 3.8.8 (ubuntu quantal to raring), I'm
> unable to change my alfa AWUS036NH mac address; a simple:
>
> ifconfig <device> down
> ifconfig <device> hw ether <random hw>
>
> results in:
>
> SIOCSIFHWADDR: Invalid argument
>
> I tried the drivers shipped with the distribution,
> compat-drivers-3.9-rc4-2-su and compat-drivers-2013-03-28-4-u aswell;
> all to no avail.

Hi!

I have the same problem with RT5370 (rt2800usb driver).
compat-drivers-v3.7.9-1 still works, so this must be a regression in 
kernels after 3.8...

bruno
