Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab0AGQCw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 11:02:52 -0500
Date: Thu, 7 Jan 2010 07:58:00 -0800
From: Greg KH <gregkh@suse.de>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Commit v2.6.31.10~7 breaks compilation
Message-ID: <20100107155800.GA15885@suse.de>
References: <alpine.LSU.2.01.1001071518030.24304@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LSU.2.01.1001071518030.24304@obet.zrqbmnf.qr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 07, 2010 at 03:19:57PM +0100, Jan Engelhardt wrote:
> Hey guys,
> 
> 
> just wanting to let you know that v2.6.31.10~7 is not appropriate for 
> 2.6.31, as there is no "ps_default" field in struct wiphy,
> and thus compilation of the module fails.

2.6.31.11 has now been released to fix this problem.

thanks,

greg k-h
