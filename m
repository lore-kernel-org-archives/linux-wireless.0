Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbYFXR5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 13:57:51 -0400
Subject: Re: [PATCH 04/13] rfkill: add parameter to disable radios by  
	default
From: Dan Williams <dcbw@redhat.com>
To: Fabien Crespel <fabien@crespel.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <g3r9hn$av5$1@ger.gmane.org>
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
	 <1214252588-30723-5-git-send-email-hmh@hmh.eng.br>
	 <g3quvb$8sa$1@ger.gmane.org>  <g3r9hn$av5$1@ger.gmane.org>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 13:56:53 -0400
Message-Id: <1214330213.23127.9.camel@localhost.localdomain> (sfid-20080624_195755_344557_A036629A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-24 at 19:06 +0200, Fabien Crespel wrote:
> Dmitry Baryshkov wrote:
> > 
> > Why not add the possibility for each rfkill-enabled radio to supply it's 
> > default state?
> > 
> 
> Indeed, I think it would be better to let the driver choose the default state 
> (initialization) instead of forcing it when registering. This would allow drivers 
> to restore the device state after a reboot or shutdown (provided the firmware 
> stores it, which is the case at least on my ASUS F3JC laptop).

Do you mean your laptop BIOS stores the value in nvram somewhere?  What
specific driver reads that value back out?

Dan

