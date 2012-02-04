Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33301 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2BDOZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Feb 2012 09:25:08 -0500
Date: Sat, 4 Feb 2012 08:25:02 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Scott Sanbar <scott.sanbar@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: BCM4331 fails to associate after suspend
Message-ID: <20120204142502.GA10858@ubuntu-mba> (sfid-20120204_152542_676403_F2FC6121)
References: <20120203222818.GA3749@ubuntu-mba>
 <4F2D0C07.1010704@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F2D0C07.1010704@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 04, 2012 at 11:44:23AM +0100, Arend van Spriel wrote:
> On 02/03/2012 11:28 PM, Seth Forshee wrote:
> > 
> > I've been looking around a bit in the b43 and bcma drivers, but so far I
> > haven't found the reason why this happens. Any help would be
> > appreciated. Let me know if there's additional information I can
> > provide.
> > 
> 
> With which kernel version do you see these issues? BCMA suspend/resume
> code has a fix in 3.3-rc1. So if you are seeing it on a 3.2 kernel,
> please give it a try.

I've tried 3.3-rc2 and the wirless-testing tree, and the problem still
exists in both.

Seth
