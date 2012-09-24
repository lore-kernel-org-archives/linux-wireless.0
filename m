Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53804 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab2IXRUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 13:20:46 -0400
Message-ID: <50609661.3010100@candelatech.com> (sfid-20120924_192050_368058_BD69AA58)
Date: Mon, 24 Sep 2012 10:20:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: info <info@tonyspcrepairs.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: compile error iw on centos 5
References: <CAPU73_t5_XjvPURXedOJGmfpRKZi9UG=_6rm7DXUBcRMDaqU8w@mail.gmail.com>  <20120924154646.GC32351@tuxdriver.com>  <07A9A66798FE4AEEBDD199D961D87597@asusPC> <1348505103.8464.16.camel@dcbw.foobar.com>
In-Reply-To: <1348505103.8464.16.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2012 09:45 AM, Dan Williams wrote:
> On Mon, 2012-09-24 at 17:06 +0100, info wrote:
>> sadly no, I've tried later versions and even iw-latest.tar.bz2 but each one
>> fails to compile with each version giving a different reason for the fail.
>
> Well, the point here was that trying to run anything nl80211-based (like
> 'iw') on Centos 5 is simply not expected to work, because Centos 5 is
> too old to support most of what 'iw' needs, both compile-time stuff and
> likely runtime stuff.  The 2.6.18 kernel that Centos 5 has was
> originally released in 2006, and that was *long* before any
> nl80211-based wifi stuff was usable.  Which means iw is quite unlikely
> to ever work there.
>
> RHEL 6 (or Centos 6) have good nl80211 support and thus would be  much
> more likely to work with 'iw'.

You can compile your own libraries and kernel and run on an old
OS though.  We end up doing that just to support older systems in
the field, and folks stuck on old OSs for whatever reason.

I think the only useful patch for this that I carry is something
for 'ip', but my trees are on github if anyone wants to give
them a try.  They mostly track upstream, but are a few months out
of date most of the time....

https://github.com/greearb

I know these compile back as far as Fedora Core 8.  Not sure it will
work on CentOS 5 or not...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

