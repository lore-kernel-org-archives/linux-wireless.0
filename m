Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbcAYRVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 12:21:32 -0500
Date: Mon, 25 Jan 2016 09:21:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Glen Lee <glen.lee@atmel.com>, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH V2 00/26] use unified firmware and add ops in cfg
Message-ID: <20160125172131.GA27361@kroah.com> (sfid-20160125_182136_203188_53CEE8CA)
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
 <87vb6hu7f0.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87vb6hu7f0.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 25, 2016 at 03:15:31PM +0200, Kalle Valo wrote:
> Glen Lee <glen.lee@atmel.com> writes:
> 
> > This patch series contains                                                      
> > * support suspend and resume functionality                                      
> > * use a unified firmware for all mode of operations(station, ap, p2p)           
> > * support Station/AP concurrency                                                
> > * increase link speed                                                           
> > * add a cfg operation for adjusting the tx power                                
> > * fix bug on p2p, WEP security and chaning virtual interface
> >
> > Changes in V2: details in each patch files.
> >  - 0004-staging-wilc1000-add-sdio-resume-suspend.patch
> 
> It's good practise to also add "staging: wilc1000: " prefix to the cover
> letter.

Yes please, otherwise it misses my filters when I go to apply patches
for a subsystem and I have to find it by hand :(
