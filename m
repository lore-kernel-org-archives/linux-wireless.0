Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:48583 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2AQBRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 20:17:11 -0500
Date: Mon, 16 Jan 2012 20:17:03 -0500 (EST)
Message-Id: <20120116.201703.109506071619281024.davem@davemloft.net> (sfid-20120117_021714_838299_2DFE893D)
To: julian.calaby@gmail.com
Cc: torvalds@linux-foundation.org, keithp@keithp.com,
	linux-wireless@vger.kernel.org, zajec5@gmail.com
Subject: Re: MBA resume wedge due to wireless fixed yet?
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGRGNgUhGs+30WpppKvH110qBMcSss3xKEoNH_Tv+ZEoKWRJhg@mail.gmail.com>
References: <CAGRGNgVL-tmY8e2hk43hQQot6YwvEWcQYwoSHLtQGj4JR+Nk3w@mail.gmail.com>
	<CA+55aFz6qAY+q+Fes4gZdit1V_XQO7hcqp+V=ytuY=XYq2Tu8Q@mail.gmail.com>
	<CAGRGNgUhGs+30WpppKvH110qBMcSss3xKEoNH_Tv+ZEoKWRJhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 17 Jan 2012 12:09:03 +1100

> Hi,
> 
> On Tue, Jan 17, 2012 at 11:57, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Mon, Jan 16, 2012 at 4:37 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>>> Hi all,
>>>
>>> I have a stupid question:
>>>
>>> On Tue, Jan 17, 2012 at 10:56, Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>> I have patches, but haven't committed them because I was kind of
>>>> expecting them to go through the wireless tree.
>>>
>>> Then why were these patches never posted to linux-wireless?
>>
>> They were posted to at least netdev, they were cc'd to the top-level
>> maintainers (both David and Linville), and the maintainers of the
>> driver itself.
> 
> I noticed all the names for the driver maintainers but my eyes must
> have skipped over David and Linville.

I poked John and told him he needs to integrate those changes ASAP.
