Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45191 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1EJUGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 16:06:13 -0400
Message-ID: <4DC99AB1.1040001@candelatech.com> (sfid-20110510_220616_718609_C3A6CC22)
Date: Tue, 10 May 2011 13:06:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC ] wireless: Support can-scan-one logic.
References: <1305057374-9875-1-git-send-email-greearb@candelatech.com> <BANLkTinngCnqYOtbt8+X8u2xMp5kApOvwA@mail.gmail.com>
In-Reply-To: <BANLkTinngCnqYOtbt8+X8u2xMp5kApOvwA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 12:59 PM, Daniel Halperin wrote:
> See inline
>
> On Tue, May 10, 2011 at 12:56 PM,<greearb@candelatech.com>  wrote:
>>
>> +
>> +       /*
>> +         printk("start_sw_scan, can_scan_one: %i  n_channels: %i\n",
>> +         local->scan_req->can_scan_one, local->scan_req->n_channels);
>> +         WARN_ON(!local->scan_req->can_scan_one);
>> +       */
>
> Remove the debug print?

I'll clean all of the comments if that is the only complaint.  Johannes didn't
like it for more substantial reasons last time...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

