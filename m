Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:36491 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbbHRRG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 13:06:59 -0400
MIME-Version: 1.0
In-Reply-To: <20150818091530.GH5610@mwanda>
References: <55D238D4.20800@broadcom.com> <ba3c67af8cbe5658154084a165785c637e5a2bc8.1439853139.git.raphael.beamonte@gmail.com>
 <20150817234628.GK5558@mwanda> <20150818091530.GH5610@mwanda>
From: =?UTF-8?Q?Rapha=C3=ABl_Beamonte?= <raphael.beamonte@gmail.com>
Date: Tue, 18 Aug 2015 13:06:39 -0400
Message-ID: <CAE_Gge0EDaE=zQp9YBDJSd_1VjU1a8-zoPkyKxqPc2THi2b=eQ@mail.gmail.com> (sfid-20150818_190728_576954_DD35C23C)
Subject: Re: [PATCHv3] staging: wilc1000: replace MALLOC_WILC_BUFFER() macro
 to avoid possible memory leak
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Arend van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-08-18 5:15 GMT-04:00 Dan Carpenter <dan.carpenter@oracle.com>:
> To be honest, I have lost track of this patchset.  If you are planning
> to redo the other patches can you send it in a new thread?

Actually, Greg already included the "return statement" and
"DECLARE_WILC_BUFFER" ones.
The replacement of printk by netdev_* needs more work on my side to
get the net_device to be able to use the netdev_* functions.
And apparently Greg already received another patch with the
"FREE_WILC_BUFFER" replacement, though I don't see it in the
staging-testing tree yet.

So, I think this patch is the last one of this patchset that has to be
treated! That's why I rebased it on top of the current staging-testing
tree on my last send.

Thanks,
Raphaël
