Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:12156 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaGAKNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 06:13:22 -0400
Message-ID: <53B289BE.10507@broadcom.com> (sfid-20140701_121326_122961_4955C489)
Date: Tue, 1 Jul 2014 12:13:18 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: treat LCNXN-PHY as extra N-PHY devices
References: <1404071205-12568-1-git-send-email-zajec5@gmail.com>	<53B141CB.7010000@broadcom.com> <CACna6rzisWW9YGQpOz9-PVD5bFg5ApzVfNSLbWmVJOYXgssqkQ@mail.gmail.com>
In-Reply-To: <CACna6rzisWW9YGQpOz9-PVD5bFg5ApzVfNSLbWmVJOYXgssqkQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30-06-14 13:04, Rafał Miłecki wrote:
> On 30 June 2014 12:54, Arend van Spriel <arend@broadcom.com> wrote:
>> On 29-06-14 21:46, Rafał Miłecki wrote:
>>> LCNXN is simply a continuation of N, e.g. code handling LCNXN revs 0 and
>>> 1 is mostly the same as for N-PHY revs 7+.
>>
>> Hi Rafał,
>>
>> LCNXN is actually a LCN phy with 2 streams (mimo).
> 
> Err, I don't think so. Could you take a closer look at this? I'm
> pretty sure LCNXN is continuation of N.

You got me. I taken a closer look. It seems to stand for e'x'tended n.
There was separate phy code for it, but in recent code it seems to be
handled by n phy code. So you are right.

> Maybe you were thinking about LCN40? I don't know much about LCN40,
> maybe it's a variation of LCN?

Probably.

Gr. AvS

