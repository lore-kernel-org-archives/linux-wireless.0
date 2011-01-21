Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37079 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1AUV3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 16:29:10 -0500
Received: by eye27 with SMTP id 27so1181802eye.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 13:29:09 -0800 (PST)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH 3/3] libertas_spi: Add support for suspend/resume
Date: Fri, 21 Jan 2011 23:27:21 +0200
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com> <1295642690-16646-4-git-send-email-anarsoul@gmail.com> <201101212225.02775.marek.vasut@gmail.com>
In-Reply-To: <201101212225.02775.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Message-Id: <201101212327.22127.anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 January 2011 23:25:02 Marek Vasut wrote:
> On Friday 21 January 2011 21:44:50 Vasily Khoruzhick wrote:
> > Add support for suspend/resume in if_spi.
> 
> Isn't there some pin to put the card asleep ? I think these LBS ones have
> it.

Is there datasheet on these cards?
 
> Also, do you need to do this via workqueue ? Can't you just do it in the
> resume handler?

Hmm, is it OK to request firmware if userspace is not ready yet?
 
> Cheers

Regards
Vasily
