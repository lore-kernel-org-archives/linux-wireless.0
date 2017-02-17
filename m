Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:62610 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933462AbdBQMti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Feb 2017 07:49:38 -0500
Date: Fri, 17 Feb 2017 20:49:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sasha Levin <alexander.levin@verizon.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [linux-stable] 4fc2942b6e kernel BUG at
 kernel/time/hrtimer.c:109!
Message-ID: <20170217124933.bfvyhc4tkzkbwhz5@wfg-t540p.sh.intel.com> (sfid-20170217_134941_399704_703F8777)
References: <20170217052607.glbumukvoz4pilvt@wfg-t540p.sh.intel.com>
 <alpine.DEB.2.20.1702171014430.3536@nanos>
 <0f58a1d0-a2e6-9430-7883-68e986ccb4c0@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <0f58a1d0-a2e6-9430-7883-68e986ccb4c0@arm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 17, 2017 at 10:09:06AM +0000, Marc Zyngier wrote:
>On 17/02/17 09:28, Thomas Gleixner wrote:
>> On Fri, 17 Feb 2017, kernel test robot wrote:
>>
>>> Hi Marc,
>>>
>>> We find this oops in linux-4.4.y. The gcc-6 compiled mainline kernel is fine.
>
>The last bit is worrying, as mainline has the exact same bug. Has it
>been tested the same way?

Nope, mainline is not tested the same way because gcc-4.6 cannot build
a mainline kernel due to gcc-plugin related build errors.

Thanks,
Fengguang
