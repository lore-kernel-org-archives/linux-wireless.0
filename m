Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:15098 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYFSWcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 18:32:22 -0400
Received: by rv-out-0506.google.com with SMTP id k40so5386646rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 15:32:22 -0700 (PDT)
Message-ID: <1ba2fa240806191532uf762d8avddfbe24aab05caf4@mail.gmail.com> (sfid-20080620_003226_420314_09870876)
Date: Fri, 20 Jun 2008 01:32:22 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 1/2] mac80211: 11d Handling - Country Information Element
Cc: johannes@sipsolutions.net, mcgrof@gmail.com,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org, assaf.krauss@intel.com
In-Reply-To: <20080619.150448.24028711.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806191316h3ca2044o407d094415fa5bf2@mail.gmail.com>
	 <1213906688.8967.112.camel@johannes.berg>
	 <1ba2fa240806191329w7aef4ccaq587915d41d999edd@mail.gmail.com>
	 <20080619.150448.24028711.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 20, 2008 at 1:04 AM, David Miller <davem@davemloft.net> wrote:
> From: "Tomas Winkler" <tomasw@gmail.com>
> Date: Thu, 19 Jun 2008 23:29:55 +0300
>
>> On Thu, Jun 19, 2008 at 11:18 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> >
>> >> >> +     if (country_ie_len < 6) {
>> >> >> +             printk(KERN_ERR "%s: country information element shorter (%d)"
>> >> >> +                     " than expected.\n", __func__, country_ie_len);
>> >> >
>> >> > Remotely exploitable security bug.
>> >
>> >> Please explain,
>> >
>> > Sending broken frames will fill the disk.
>>
>> I see thanks (yeah, distors doesn't make separate log partitions as default)
>
> How distros do their partitioning is neither here not there.  And even
> if they make a seperate log partition, that means it's still exploitable
> in that you will no longer get the other non-spam log messages that might
> be important to know about.
>
> Any kernel log message triggerable remotely without any kind of rate
> limiting is a bug.

Will keep in mind
Thanks
Tomas
