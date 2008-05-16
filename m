Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sacred.ru ([62.205.161.221]:54796 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYEPP42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 11:56:28 -0400
Message-ID: <482DAE03.9070902@openvz.org> (sfid-20080516_175632_500902_236C95EC)
Date: Fri, 16 May 2008 19:53:39 +0400
From: Pavel Emelyanov <xemul@openvz.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/7][MAC8021]: Fix one more call to synchronize_rcu in
 atomic context.
References: <4821CE54.9000401@openvz.org> <482D6A80.6030804@openvz.org> <20080516151620.GC6510@tuxdriver.com>
In-Reply-To: <20080516151620.GC6510@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Fri, May 16, 2008 at 03:05:36PM +0400, Pavel Emelyanov wrote:
> 
>> Sorry for bothering you, I guess that you're very busy now, 
>> but what are you plans about this set?
>>
>> After I saw my first set included in some wireless git update,
>> I thought this one would be in some of the next ones (since
>> this set fixes some bugs in mesh tables), and started waiting.
>>
>> Here's a new wireless git update and this set is still not in.
>> Shall I resubmit one?
> 
> Pavel,
> 
> I still have your patchset.  I'm still working on clearing my
> backlog, as well as waiting for some fixes to make the round-trip
> net-2.6->linux-2.6->net-next-2.6.  The combination of that and the
> fact that your patch hit locking and "the usual suspects" had not
> yet commented on it made me decide to wait until the next round.
> 
> If you are desperate to see them sooner, I could probably put them
> in the -testing tree early?  Let me know if you would like that.

No, this is not critical for me. You may keep this set in any
place in your queue. I just wanted to make sure, that this set
didn't get accidentally lost and no additional help from me is
required (at least for now).

> John

Thanks,
Pavel
