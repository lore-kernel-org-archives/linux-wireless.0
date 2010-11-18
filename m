Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33544 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab0KRSLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 13:11:08 -0500
Message-ID: <4CE56C38.30500@candelatech.com>
Date: Thu, 18 Nov 2010 10:11:04 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org> <1290020005.3777.6.camel@jlt3.sipsolutions.net> <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost> <4CE4D41F.1080005@kernel.org> <4CE56892.9090606@candelatech.com> <4CE56AAB.7080507@kernel.org>
In-Reply-To: <4CE56AAB.7080507@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2010 10:04 AM, Tejun Heo wrote:
> Hello, Ben.
>
> On 11/18/2010 06:55 PM, Ben Greear wrote:
>> I understand your desire for a stack dump, but it appears that sysrq-t
>> isn't getting everything you want, for whatever reason.
>
> Can you please try again and investigate why it's not working?  If
> task dump is not working as expected, there is a much more serious
> problem than wireless locking up.
>
>> Does my explanation of the rtnl deadlock that I posted near the beginning
>> of this thread (with some backtraces to back that up) make sense, or
>> are my assumptions invalid?
>
> Yes, it makes sense.  At this point, I'm fairly sure that something is
> holding the workqueue but I really can't tell anything without proper
> stack dump.

I'm swamped with work today...but hopefully will get back to this later
today or tomorrow.

Thanks,
Ben

>
> Thanks.
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

