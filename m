Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab1LIVuC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 16:50:02 -0500
Date: Fri, 9 Dec 2011 13:45:07 -0800
From: Greg KH <gregkh@suse.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, stable@kernel.org
Subject: Re: [PATCH] bcma: support for suspend and resume
Message-ID: <20111209214507.GB29683@suse.de> (sfid-20111209_225007_747794_64203914)
References: <1323465367-5130-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1323465367-5130-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 09, 2011 at 10:16:07PM +0100, Rafał Miłecki wrote:
> bcma used to lock up machine without enabling PCI or initializing CC.
> 
> Cc: stable@kernel.org

This address is gone, please use stable@vger.kernel.org in the future.

thanks,

greg k-h
