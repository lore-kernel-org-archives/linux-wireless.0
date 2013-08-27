Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46758 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3H0Fwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 01:52:41 -0400
Received: by mail-lb0-f177.google.com with SMTP id p5so2146376lbi.36
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 22:52:40 -0700 (PDT)
Date: Tue, 27 Aug 2013 07:52:30 +0200
From: Tobias Waldekranz <tobias@waldekranz.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mwifiex: add missing endian conversions
Message-ID: <20130827055230.GB14350@gmail.com> (sfid-20130827_075244_922257_D05A7A9D)
References: <20130826071806.GA3035@gmail.com>
 <477F20668A386D41ADCC57781B1F70430EAF1FEDA3@SC-VEXCH1.marvell.com>
 <477F20668A386D41ADCC57781B1F70430EAF1FEDB2@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EAF1FEDB2@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 26, 2013 at 12:49:57PM -0700, Bing Zhao wrote:
> Hi Tobias,
> 
> > Thanks for your patch.
> > It doesn't apply to wireless or wireless-next trees.
> > 
> > Which git tree are you using?
> 
> Never mind. John has merged the patch already.
> 
> Regards,
> Bing

Ok, thanks for picking up the slack :)

It was based on linux-stable/linux-3.10.y, I will base any subsequent
patches on wireless-next.

Thanks
 - wkz
