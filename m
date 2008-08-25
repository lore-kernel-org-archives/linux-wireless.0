Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.188]:52023 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYHYTdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 15:33:02 -0400
Received: by gv-out-0910.google.com with SMTP id e6so353371gvc.37
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 12:33:00 -0700 (PDT)
Message-ID: <1ba2fa240808251233n214048c7ife265c473331d618@mail.gmail.com> (sfid-20080825_213307_289353_FE257FCB)
Date: Mon, 25 Aug 2008 22:33:00 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-next-2.6 2008-08-22
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20080825184921.GA17297@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080822234632.GA12922@tuxdriver.com>
	 <1ba2fa240808221821l3fcc4091l57caba03f86526ea@mail.gmail.com>
	 <20080825184921.GA17297@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 25, 2008 at 9:49 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sat, Aug 23, 2008 at 04:21:23AM +0300, Tomas Winkler wrote:
>> On Sat, Aug 23, 2008 at 2:46 AM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > Dave,
>> >
>> > Here is my current stack of updates for 2.6.28 -- included is an
>> > orinoco update to support WPA on certain firmware, the new libertas_tf
>> > driver, a number of cleanups, and a variety of other driver updates.
>> > Still more to come, but I think it is better to get these out rather
>> > than wait for the rest...
>> >
>> > Please let me know of there are problems!
>> >
>>
>> Missing this one
>> iwlwifi: allow consecutive scans in unassociated state
>> http://marc.info/?l=linux-wireless&m=121919791411147&w=2
>> Thanks
>> Tomas
>
> Hence the phrase "Still more to come"...
>
Sure, this was just integral part of  the direct probe/association
fixes included in this bulk
Tomas
