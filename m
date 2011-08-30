Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab1H3SPC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 14:15:02 -0400
Date: Tue, 30 Aug 2011 11:14:52 -0700
From: Greg KH <gregkh@suse.de>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110830181452.GA24769@suse.de> (sfid-20110830_201507_094479_41A7C3CB)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
 <20110827143513.GN3775@shale.localdomain>
 <20110827145003.GA9405@suse.de>
 <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
 <20110827152144.GA10126@suse.de>
 <20110830014257.GI15771@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110830014257.GI15771@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 06:42:57PM -0700, Henry Ptasinski wrote:
> The brcmsmac driver has architectural alignment with our drivers for other
> operating systems, and we intend to to enhance and maintain this driver in 
> parallel with drivers for other operating systems.  Maintaining alignment
> between our Linux driver and drivers for other operating systems allows us to
> leverage feature and chip support across all platforms.

Just curious, if you really are going to try to do this, how are you
going to handle the issue when others change the in-kernel driver in
ways that you are not going to be allowed to make to your "internal"
copy of the driver?

Also, how are you going to handle any GPL-only changes that happen to
the code as well?  Do you have some process in place to ensure that all
contributions will have the proper copyright releases on it to allow you
to make the same changes to your internal versions?

This all is a very difficult and time-consuming task, are you sure you
are all up to it and have properly discussed it with your legal team,
management team, and with the kernel community?

thanks,

greg k-h
