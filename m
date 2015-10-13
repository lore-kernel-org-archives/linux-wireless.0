Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35534 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbJMSzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 14:55:24 -0400
Received: by iofl186 with SMTP id l186so31542290iof.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2015 11:55:24 -0700 (PDT)
Date: Tue, 13 Oct 2015 13:54:24 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] wireless-regdb: Add 160 MHz channel bandwidth for
 Greenland (GL)
Message-ID: <20151013185424.GE50632@ubuntu-hedt> (sfid-20151013_205528_423631_AB72FC1D)
References: <1444072321-20728-1-git-send-email-jouni@qca.qualcomm.com>
 <20151013183758.GC50632@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151013183758.GC50632@ubuntu-hedt>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 13, 2015 at 01:37:58PM -0500, Seth Forshee wrote:
> On Mon, Oct 05, 2015 at 10:11:57PM +0300, Jouni Malinen wrote:
> > This extends regulatory rules for Greenland to allow 160 MHz VHT
> > channels. This was missed in the earlier set of patches that added 160
> > MHz for large number of countries.
> > 
> > Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> 
> Applied all 5 patches, thanks.

Or maybe not. After I pushed out master-2015-10-13 I noticed that I
somehow missed the first patch. It's applied now, sorry about that.
