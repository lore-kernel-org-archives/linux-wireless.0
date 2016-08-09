Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37264 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbcHIGhY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 02:37:24 -0400
Message-ID: <1470724641.28531.6.camel@sipsolutions.net> (sfid-20160809_083727_581274_539DA8D2)
Subject: Re: [BUG] 4.8-rc1: wlcore: NULL pointer dereference in
 wlcore_op_get_expected_throughput
From: Johannes Berg <johannes@sipsolutions.net>
To: "H. Nikolaus Schaller" <hns@goldelico.com>,
	linux-wireless@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Discussions about the Letux Kernel
	<letux-kernel@openphoenux.org>
Date: Tue, 09 Aug 2016 08:37:21 +0200
In-Reply-To: <4FEB5780-826B-49C3-81E9-D361CD12DD4A@goldelico.com> (sfid-20160808_232959_664351_C51374E0)
References: <4FEB5780-826B-49C3-81E9-D361CD12DD4A@goldelico.com>
	 (sfid-20160808_232959_664351_C51374E0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-08-08 at 23:26 +0200, H. Nikolaus Schaller wrote:
> Here is what I see in 4.8-rc1 on Pyra device after typing "poweroff".
> I hope someone knows what it means.
> 
> BR and thanks,
> Nikolaus

[snip]

> [  616.041894] [<bf4de050>] (wlcore_op_get_expected_throughput
> [wlcore]) from [<bf40cf20>] (sta_set_sinfo+0xc18/0x1110 [mac80211])
> [  616.054542] [<bf40cf20>] (sta_set_sinfo [mac80211]) from 
[snip]

This is already fixed by 2439ca0402091badb24415e1b073ba12b34ba423

johannes
> 
