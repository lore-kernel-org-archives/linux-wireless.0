Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbYBYCEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 21:04:21 -0500
Date: Sun, 24 Feb 2008 18:04:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: can't bring up wlan0
Message-Id: <20080224180419.b7b44524.akpm@linux-foundation.org> (sfid-20080225_020435_249055_0DDC158F)
In-Reply-To: <1203904312.3082.156.camel@debian.sh.intel.com>
References: <20080223153142.da9fc4e4.akpm@linux-foundation.org>
	<1203904312.3082.156.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 25 Feb 2008 09:51:52 +0800 Zhu Yi <yi.zhu@intel.com> wrote:

> 
> On Sat, 2008-02-23 at 15:31 -0800, Andrew Morton wrote:
> > t61p:/home/akpm# ifconfig wlan0 up
> > SIOCSIFFLAGS: No such device
> 
> Did dmesg tell something about missing firmware?
> 

Nope, but things got a lot better when I turned the wireless kill switch
back on. oops ;)

I don't think ipw2200 worked that way?  I'm fairly sure I used to be able
to configure the interface whichever way the switch was positioned?

