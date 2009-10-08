Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:19844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737AbZJHQaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 12:30:07 -0400
Received: by fg-out-1718.google.com with SMTP id 22so34179fge.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2009 09:28:19 -0700 (PDT)
Message-ID: <4ACE131E.3080908@lwfinger.net>
Date: Thu, 08 Oct 2009 11:28:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: James Grossmann <cctsurf@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Prism54/p54pci
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com>
In-Reply-To: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2009 04:00 PM, James Grossmann wrote:
> I have the gigafast WF728-AEX, which doesn't seem to work with the
> p54pci drivers, I was previously using it with my Thinkpad T23 under
> Gentoo (gentoo kernels 2.6.29 and 2.6.30), and could only use the
> 1.0.4.3 firmware, now, I am using it under Ubuntu 9.04
> (2.6.28-15-generic kernel) on the same computer, and find that I have
> to load the prism54 driver to make it work.
> I noticed that you were considering this to be depricated, I hope that
> you can help me to make p54pci work!

As it works with 2.6.29 and 2.6.30 kernels, but not with 2.6.28, it 
seems likely that you need a later version of the driver. Does Ubuntu 
have a package for compat-wireless? If so, install it. If not, you 
will need to install from source.

Larry
