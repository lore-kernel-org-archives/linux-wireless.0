Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34439 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbbHaRre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 13:47:34 -0400
Received: by wicjd9 with SMTP id jd9so7661250wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 10:47:33 -0700 (PDT)
Message-ID: <55E49334.5000103@gmail.com> (sfid-20150831_194738_076729_4F9F4D48)
Date: Mon, 31 Aug 2015 19:47:32 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: NetworkManager crashing
References: <55DF3E75.1080305@gmail.com> <1441035810.2718.6.camel@redhat.com>
In-Reply-To: <1441035810.2718.6.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 31-08-15 17:43, Dan Williams wrote:
> On Thu, 2015-08-27 at 18:44 +0200, Arend van Spriel wrote:
>> Hi Dan,
>>
>> I ran into issue when NetworkManager keeps crashing/respawning. I have
>> no idea what happened. My laptop was rebooted (might been my sons work)
>> and this was the situation I stumbled upon. Running 4.1 kernel on Linux
>> Mint. NetworkManager version is 0.9.8.8.
> 
> Odd, can you get any more log messages out of the machine?  Or perhaps a
> backtrace?  Looks like it's happening quite early in boot, before
> anything would really get configured...

Yikes. My mistake. I have two libnl-3 versions installed and
NetworkManager loaded the wrong one. Doing walk of shame here.

Regards,
Arend

