Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37152 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab1EGAeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 20:34:23 -0400
Message-ID: <4DC49386.6070503@candelatech.com> (sfid-20110507_023450_080520_B1E00588)
Date: Fri, 06 May 2011 17:34:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Biescting between mainline and wireless-testing
References: <BANLkTik3TtCcy2cJkMbRTpsn4x4XE9=naQ@mail.gmail.com>
In-Reply-To: <BANLkTik3TtCcy2cJkMbRTpsn4x4XE9=naQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2011 04:51 PM, Rafał Miłecki wrote:
> I suspect we have some ugly (hard trackable) regression between
> mainline and wireless-testing. It sounds impossible, but this seems to
> affect Broadcom cards and looks like not related to ssb or b43.
>
> Today I've compiled 2.6.38 and 2.6.39-rc6, both work GOOD.
> I've compiled wireless-testing and it failed, BAD.
> I've reverted all recent ssb patches from top and it still fails BAD.
>
> What would be the easiest way to try bisecting? I can see
> wireless-testing merges mainline quite often. Can I use some trick on
> checkouted wireless-testing? Do I have to checkout mainline and merge
> wireless-testing into it? Something even different?
>

git bisect can handle it...I've spent some quality time finding
bugs in ath9k with that lately...

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
