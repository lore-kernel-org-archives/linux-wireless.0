Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3FAVr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 17:47:56 -0400
Message-ID: <1370123268.13091.0.camel@jlt4.sipsolutions.net> (sfid-20130601_234805_417227_D0F70944)
Subject: Re: BK, VI, VO tx queue stopped unexpectedly
From: Johannes Berg <johannes@sipsolutions.net>
To: Huawei Yang <harvey.huawei.yang@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 01 Jun 2013 23:47:48 +0200
In-Reply-To: <20130601110149.GA6504@gmail.com> (sfid-20130601_130217_716513_33BCA89A)
References: <20130601110149.GA6504@gmail.com>
	 (sfid-20130601_130217_716513_33BCA89A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-06-01 at 19:01 +0800, Huawei Yang wrote:
> Hi guys
> 
> I am writing a nl80211/cfg80211 driver for my wifi chip. I am testing
> my chip under the AP mode with hostapd. I use the kernel 3.0. I start
> the AP and check that all four tx queues are start, then I start a udp
> stream of BE from Ap to the station. After that I find other three tx
> queues stopped. I am sure that my driver dose not stop them. Is this a
> kernel machinesm ? 

No mac80211? In that case, it has to be your driver ... if the queues
are really stopped. Or maybe you just leaked the frames and messed up
completely that way...

johannes

