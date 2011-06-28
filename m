Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48760 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118Ab1F1UVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 16:21:38 -0400
Date: Tue, 28 Jun 2011 13:19:15 -0700
From: Greg KH <greg@kroah.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: implement testmode rx command
Message-ID: <20110628201915.GA19616@kroah.com> (sfid-20110628_222149_106259_A63DE60A)
References: <20110627153610.16774.65919.stgit@localhost6.localdomain6>
 <20110628201836.GA18749@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110628201836.GA18749@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 28, 2011 at 01:18:36PM -0700, Greg KH wrote:
> On Mon, Jun 27, 2011 at 06:36:10PM +0300, Kalle Valo wrote:
> > Add new testmode command for retrieving rx reports from firmware.
> > 
> > Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> This patch breaks the build.
> 
> Please test your patches before sending them out, it causes lots of
> problems and annoys me when you don't.

Oh, and the error is:

ERROR: "ar6000_testmode_rx_report_event" [drivers/staging/ath6kl/ath6kl.ko] undefined!

