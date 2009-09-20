Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38941 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZITSZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2009 14:25:12 -0400
Subject: Re: [PATCH 1/3] libertas: support boot commands to write
 persistent firmware and bootloader
From: David Woodhouse <dwmw2@infradead.org>
To: Brian Cavagnolo <brian@cozybit.com>, dcbw@redhat.com,
	Andrey Yurovsky <andrey@cozybit.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <487f84aa.1f068e0a.7ee7.3360@mx.google.com>
References: <487f84aa.1f068e0a.7ee7.3360@mx.google.com>
Content-Type: text/plain
Date: Sun, 20 Sep 2009 11:25:05 -0700
Message-Id: <1253471105.6317.167.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-15 at 17:45 -0700, Brian Cavagnolo wrote:
> Add locking and non-locking versions of if_usb_prog_firmware to support
> programming firmware after and before driver bring-up respectively.
> Add more suitable error codes for firmware programming process.
> Add capability checks for persistent features before attempting to use them.
> 
> Based on patches from Brajesh Dave and Priyank Singh.
> 
> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>

Grrrr. We already ripped this _out_ of the driver once, and Dan
implemented a tool to do it in userspace where it belongs.

What was wrong with using the tool at git.infradead.org/libertas-flash? 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

