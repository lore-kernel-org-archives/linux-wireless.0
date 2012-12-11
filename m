Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:28120 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2LKTjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 14:39:48 -0500
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Date: Tue, 11 Dec 2012 11:42:49 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Subject: Re: ACS and Hostapd
Message-ID: <20121211194249.GT15974@pogo> (sfid-20121211_203951_582485_976D7D96)
References: <20121123081444.GA6028@markyou.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121123081444.GA6028@markyou.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 23, 2012 at 01:44:51PM +0530, Yogesh Ashok Powar wrote:
> Hi Luis,
> 
> I was looking at your patches on the linux-wireless mailing list
> regarding ACS feature addition in hostapd.
> 
> It is seen that you went till v8 patches and still the patches are not
> seen upstream?

Correct.

> Is there any specific reason for this patches not being accepted?

It didn't get good test coverage and by the time I got results from Jouni
on his test I already lost interest on the code. If anyone wants to work
on it and enhance it feel free to do so.

> I am refering http://marc.info/?l=linux-wireless&m=131257363303693 seems
> like all in one patch. But I have trouble finding correct git base for
> it; since patch doens't apply cleanly even when I take hostap.git back
> to Jul end of 2011. For v7, 1 through 3 apply cleanly but not 4th.
> 
> Or I am I looking at some wrong hostapd git?

It should have been the same date / tag around when I submitted it. Sorry
I do not recall the exact commit.

  Luis
