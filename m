Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34619 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118Ab1F1UVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 16:21:36 -0400
Date: Tue, 28 Jun 2011 13:18:36 -0700
From: Greg KH <greg@kroah.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: implement testmode rx command
Message-ID: <20110628201836.GA18749@kroah.com> (sfid-20110628_222148_486926_57BACF93)
References: <20110627153610.16774.65919.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110627153610.16774.65919.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 27, 2011 at 06:36:10PM +0300, Kalle Valo wrote:
> Add new testmode command for retrieving rx reports from firmware.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

This patch breaks the build.

Please test your patches before sending them out, it causes lots of
problems and annoys me when you don't.

greg k-h
