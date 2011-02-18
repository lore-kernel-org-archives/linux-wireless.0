Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab1BRLd7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 06:33:59 -0500
Date: Fri, 18 Feb 2011 12:32:55 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/14] rtlwifi: rtl8192cu: Add driver
Message-ID: <20110218113254.GB2270@redhat.com>
References: <4d5d9088.+yc+uIIeTakXOvtB%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d5d9088.+yc+uIIeTakXOvtB%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 17, 2011 at 03:18:00PM -0600, Larry Finger wrote:
> Add driver rtl192cu. The individual parts are:
> 
>  1/14: Make changes in rtlwifi/rtl8192ce/reg.h to support rtl8192cu
>  2/14: Make changes in rtlwifi/rtl8192ce/def.h to support rtl8192cu
>  3/14: Modify some rtl8192ce routines for merging rtl8192cu
>  4/14: Add headers for rtl8187cu
>  5/14: Modify wifi.h for rtl8192cu
>  6/14: Move common parts of rtl8192ce/phy.c
>  7/14: Add routines dm, fw, led and sw
>  8/14: Add routine hw
>  9/14: Add routine mac
> 10/14: Add routine phy
> 11/14: Add routine rf
> 12/14: Add routine table
> 13/14: Add routine trx
> 14/14: Modify buiild system for rtl8192cu
> 
> Signed-off-by: George <george0505@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

There are big parts that need serious cleanup i.e. they are
at staging quality, but I'm fine for accept patches (after
fixing endianes problem, I wrote in other email), and cleanup
driver lately. I'll probably send some cleanup patches for
things I dislike the most.

Thanks for fixing Hungarian notation.
Stanislaw
