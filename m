Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:30324 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZCFWAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 17:00:22 -0500
Received: by rv-out-0506.google.com with SMTP id g37so690074rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 14:00:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090306143612.GA3712@tuxdriver.com>
References: <43e72e890903041335n47a70186u4a7aeb304f8b6979@mail.gmail.com>
	 <1236275668.6612.134.camel@rc-desk>
	 <43e72e890903051124t42ce5c7blfd741da4a2b4fa79@mail.gmail.com>
	 <49B056FA.2020605@canonical.com>
	 <43e72e890903051513n44cf5281y32cc11e06754aa3@mail.gmail.com>
	 <49B06DA6.7070000@canonical.com>
	 <43e72e890903051633w7880648djdd798c5a28285a6b@mail.gmail.com>
	 <20090306143612.GA3712@tuxdriver.com>
Date: Fri, 6 Mar 2009 14:00:20 -0800
Message-ID: <43e72e890903061400v43482ae9y3a0d8091d2182462@mail.gmail.com> (sfid-20090306_230026_317428_8F7AB75B)
Subject: Re: Please apply to stable: cfg80211: add support for custom firmware
	regulatory solutions
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: tim.gardner@canonical.com,
	reinette chatre <reinette.chatre@intel.com>,
	"stable@kernel.org" <stable@kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 6, 2009 at 6:36 AM, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, Mar 05, 2009 at 04:33:37PM -0800, Luis R. Rodriguez wrote:
>> On Thu, Mar 5, 2009 at 4:26 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
>
>> > What is the downside of just turning OLD_REG back on for 2.6.28?
>>
>> You default to the "US" regulatory domain so channels 12-14 will not
>> be available by default. This is also why we offloaded regulatory crap
>> to userspace in the first place, so you won't have to upgrade your
>> kernel based on reg changes or fixes.
>>
>> I'll send a patch to enable passive scan on channels 12-14 for the
>> world regulatory domain. That and the 5 GHz patch should at least let
>> you see channels 12-14 with a fix from userspace. This can also go
>> into 28 for the world regulatory domain and since it would be fixing
>> an issue maybe we should consider it.
>>
>> Thoughts John?
>
> Honestly I don't think it is worth swizzling -stable for this.

OK then Tim -- best is to upgrade the userspace wireless-regdb once
the patches get merged.

  Luis
