Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:45695 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbYF3QG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 12:06:28 -0400
Message-ID: <486904D4.4010705@lwfinger.net> (sfid-20080630_180631_942585_08D5BDF0)
Date: Mon, 30 Jun 2008 11:07:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Add quality output to iwlist and iwconfig
References: <4868fe45.swzEykllJP3Ow73U%Larry.Finger@lwfinger.net>	 (sfid-20080630_173834_531803_0FC8E191) <1214840530.5507.52.camel@johannes.berg>
In-Reply-To: <1214840530.5507.52.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2008-06-30 at 10:39 -0500, Larry.Finger@lwfinger.net wrote:
>> The p54 driver family reports a quality of 0 in iwconfig and iwlist
>> output. This patch calculates a quality number as a percentage of the
>> rssi to the maximum signal of 127 reported as the maximum signal.
> 
> Unrelated, do you have a p54 card? Does it work? I wasn't sure whether
> the tx-info sbk->cb change broke it or not after I fixed up some things
> there.

It is DW1450, which is a p54usb. It works with the latest wireless 
testing, at least in b/g/mode. I don't have an 802.11a AP to try the 5 
GHz mode.

Larry
