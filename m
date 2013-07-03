Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:64986 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab3GCSpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 14:45:39 -0400
Received: by mail-qc0-f171.google.com with SMTP id n1so314557qcw.30
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 11:45:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EA2E06694@SC-VEXCH1.marvell.com>
References: <20130703015653.82651FAAD5@dev.laptop.org>
	<477F20668A386D41ADCC57781B1F70430EA2E06694@SC-VEXCH1.marvell.com>
Date: Wed, 3 Jul 2013 12:45:39 -0600
Message-ID: <CAMLZHHQXvJiThvofbgdGRtihDcCbQRe-xoU7KLDKZx4VjWRjeg@mail.gmail.com> (sfid-20130703_204546_006076_5918A794)
Subject: Re: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 3, 2013 at 12:41 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Perhaps you are talking about unloading driver (rmmod mwifiex_sdio) instead?

Yes - or going into unpowered suspend, or powering down the computer.
All of those trigger the "remove card" path which is what I wanted to
refer to.

Thanks
Daniel
