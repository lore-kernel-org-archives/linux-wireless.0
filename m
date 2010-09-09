Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab0IIFW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 01:22:56 -0400
Date: Wed, 8 Sep 2010 21:27:17 -0700
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: ath6kl: Eliminating the symlink to 2.0 header
	files
Message-ID: <20100909042717.GA19285@kroah.com>
References: <1283984388-5100-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283984388-5100-1-git-send-email-vmehta@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 08, 2010 at 03:19:48PM -0700, Vipin Mehta wrote:
> Moving the AR6002 hw 2.0 specific register definitions files from
> the hw.0 directory to a new directory, 'hw' within hw2.0.

That worked, thanks.

greg k-h
