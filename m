Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27979 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1LTTMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 14:12:31 -0500
Date: Tue, 20 Dec 2011 11:12:28 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] atheros-wireless: fix sparse warnings ho ho ho
Message-ID: <20111220191228.GC15071@tux> (sfid-20111220_201239_685878_4A9CA633)
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
 <4EF0DB90.50100@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4EF0DB90.50100@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 20, 2011 at 01:01:36PM -0600, Larry Finger wrote:
> On 12/20/2011 12:46 PM, Luis R. Rodriguez wrote:
> >From: Luis R. Rodriguez<mcgrof@qca.qualcomm.com>
> >
> >Here's a slew of sparse warning fixes for all Atheros wireless drivers.
> >These have been itching me for a while now. I ask all patch submitters
> >and driver maintainers to please run their patches with these two tests:
> >
> >make C=1 M=drivers/net/wireless/ath/
> >
> >And then if all is happy try:
> >
> >make C=2 CF="-D__CHECK_ENDIAN__" M=drivers/net/wireless/ath/
> 
> Why not follow a suggestion that Johannes made to me? Add the line
> 
> ccflags-y += -D__CHECK_ENDIAN__
> 
> To the bottom of the make file(s). That way they only need one run.
> Then enforce the rule by not ACKing any patches with too many of the
> endian warnings, and do not allow any of the others.

Awesome idea.

  Luis
