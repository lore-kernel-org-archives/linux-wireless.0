Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbbISE7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 00:59:32 -0400
Date: Fri, 18 Sep 2015 20:00:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 03/34] staging: wilc1000: rename strHostIFmsg
Message-ID: <20150919030006.GA28582@kroah.com> (sfid-20150919_070201_664788_706D744B)
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
 <1442567496-29331-3-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442567496-29331-3-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 18, 2015 at 06:11:05PM +0900, Tony Cho wrote:
> This patch changes the name, strHostIFmsg simply to msg because the
> camelcase notation is not recommended in Linux.
> 
> Signed-off-by: Tony Cho <tony.cho@atmel.com>

Because of the other patches I didn't accept, and I think because of
patches that community members sent in, this patch doesn't apply
(patches 1 and 2 I had to do by hand, but I don't want to keep doing
that...)

So can you rebase this series on my staging-testing branch and resend
them?

thanks,

greg k-h
