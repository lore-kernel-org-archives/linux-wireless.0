Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:39156 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaKADl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 23:41:27 -0400
Received: by mail-qc0-f180.google.com with SMTP id o8so6952441qcw.11
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2014 20:41:26 -0700 (PDT)
From: "S. Gilles" <sgilles@terpmail.umd.edu>
Date: Fri, 31 Oct 2014 23:41:18 -0400
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "S. Gilles" <sgilles@terpmail.umd.edu>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: Boot failure with bad RIP value
Message-ID: <20141101034118.GA20771@number18> (sfid-20141101_044131_940125_D42B9FFA)
References: <20141013234509.GD22088@number18>
 <543C9B66.6050705@lwfinger.net>
 <20141014041313.GF22088@number18>
 <20141031135636.GB21718@number18>
 <5453A5CF.90107@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5453A5CF.90107@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2014 at 10:07:59AM -0500, Larry Finger wrote:
> On 10/31/2014 08:56 AM, S. Gilles wrote:
> >> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
> >
> > Any progress on this, or duplication?  If this isn't replicable with
> > the information in Bugzilla, I can provide anything requested.
> 
> Thanks for posting the PCI ID. I am currently on a family vacation, and I have 
> had little time for driver problems, and none for chasing missing information.

My apologies, I didn't realize you were still away.

> The attached patches should fix the kernel crashes; however, I doubt that the 
> driver will work. There seems to be a problem with DMA buffers that I have not 
> had time to find.

For the sake of followp, I can confirm on my machine: the boot is fine
but no /dev/wlan0. Thanks for the patches, I'll remain available to
test any more if needed.

-- 
S. Gilles
