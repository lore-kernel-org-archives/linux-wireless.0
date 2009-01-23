Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:18815 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbZAWMkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 07:40:17 -0500
Received: by ug-out-1314.google.com with SMTP id 39so2981ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 04:40:15 -0800 (PST)
Subject: Re: [BUG] latest wireless-testing (compat-wireless) doesn't work
 with iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <49792772.7020206@lwfinger.net>
References: <1232672850.7913.6.camel@maxim-laptop>
	 <1232674156.4112.1.camel@maxim-laptop>  <49792772.7020206@lwfinger.net>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 14:40:10 +0200
Message-Id: <1232714410.32703.0.camel@maxim-laptop> (sfid-20090123_134023_250845_E997F5A8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-01-22 at 20:12 -0600, Larry Finger wrote:
> Maxim Levitsky wrote:
> > I just installed it again with all default options, and still same thing
> > I also noticed wierd AP names like:
> > 
> >  wlan0: associate with AP ffff88005463a9e0
> 
> As you have seen, the commit with the bug that prevents a connection has been found.
> 
> The funny printing of MAC addresses is due to the newer code using the %pM formatting that
> is not present in older kernels. You can ignore that.
> 
> Larry
Thanks, works fine now

Best regards,
	Maxim Levitsky

