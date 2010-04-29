Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24489 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab0D2AjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 20:39:09 -0400
From: "Xu, Martin" <martin.xu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "ath9k-devel@lists.ath5k.org" <ath9k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 29 Apr 2010 08:39:02 +0800
Subject: RE: kernel warning on 2.6.33 ath9k
Message-ID: <FC2FB65B4D919844ADE4BE3C2BB739AD1E4FB5B1@shsmsx501.ccr.corp.intel.com>
References: <1272406104-6870-1-git-send-email-benoit.papillault@free.fr>
 <1272438045.2772.6.camel@jm-desktop>
 <FC2FB65B4D919844ADE4BE3C2BB739AD1E4FB31B@shsmsx501.ccr.corp.intel.com>
 <20100428140446.GA2912@tuxdriver.com>
In-Reply-To: <20100428140446.GA2912@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: John W. Linville [mailto:linville@tuxdriver.com]
> Sent: Wednesday, April 28, 2010 10:05 PM
> To: Xu, Martin
> Cc: ath9k-devel@lists.ath5k.org; linux-wireless@vger.kernel.org
> Subject: Re: kernel warning on 2.6.33 ath9k
> 
> On Wed, Apr 28, 2010 at 04:01:45PM +0800, Xu, Martin wrote:
> > Hi
> > I found that kernel reports below warning when using ath9k in kernel 2.6.33.
> > Someone can kindly tell me whether it is the new found issue or the issue is
> known and has been fixed in later commit in git tree?
> > Thanks!
> 
> Looks like this:
Yes, just this, thanks. 

