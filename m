Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:57612 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab1C2CcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 22:32:17 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2T2W90v021346
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 22:32:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 0C41B1E067F
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 22:32:08 -0400 (EDT)
Message-ID: <4D9144AC.7040705@lockie.ca>
Date: Mon, 28 Mar 2011 22:32:12 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: what does this mean
References: <4D8E96B5.7090707@lockie.ca> <AANLkTimNtNruB5Maoa5EOkK_zJ35oEsP35-f8jvS88hm@mail.gmail.com>
In-Reply-To: <AANLkTimNtNruB5Maoa5EOkK_zJ35oEsP35-f8jvS88hm@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/11 07:53, Mohammed Shafi wrote:
> On Sun, Mar 27, 2011 at 7:15 AM, James <bjlockie@lockie.ca> wrote:
>> I tried the 2011 03 26 compat-wireless and it gives this error when I
>> try a scan (it finds some networks but I know there are more).
>>
>> sudo iw dev wlan0 scan | grep -i ssid
>>
>> ath: timeout (100000 us) on reg 0x9c20: 0x00000000 & 0x00000001 !=
>> 0x00000001
>> ath: Could not kill baseband RX
> James, this is a fatal error.
Is there anyway to increase the timeout or reset the hardware without
rebooting?
