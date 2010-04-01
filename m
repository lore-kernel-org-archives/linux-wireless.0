Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab0DAQwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 12:52:30 -0400
Date: Thu, 1 Apr 2010 09:51:44 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
	AKML <linux-arm-kernel@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	Sven Neumann <s.neumann@raumfeld.com>
Subject: Re: Memory corruption with 2.6.32.10, but not with 2.6.34-rc3
Message-ID: <20100401165144.GB1138@suse.de>
References: <20100401132156.GJ30807@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100401132156.GJ30807@buzzloop.caiaq.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 01, 2010 at 03:21:56PM +0200, Daniel Mack wrote:
> 
> I can cherry-pick things if anyone pin-points something and run
> lont-time tests again. Any pointer appreciated.

Oh, how about running 'git bisect' to try to find the solution?  Just
remember to reverse 'good' and 'bad' for when you tell git bisect what
the results are.

thanks,

greg k-h
