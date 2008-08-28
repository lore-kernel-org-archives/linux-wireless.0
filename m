Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46348 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYH1MeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:34:14 -0400
Subject: Re: [PATCH 06/11] iwlwifi: fix apm_stop
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <1ba2fa240808280421g642ddc62j7541837f874f79df@mail.gmail.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219926807.6064.17.camel@californication>
	 <1ba2fa240808280421g642ddc62j7541837f874f79df@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 16:34:10 +0200
Message-Id: <1219934050.6064.89.camel@californication> (sfid-20080828_143418_626653_68319CF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
> >> cleared which disabled moving device to D0U state.
> >
> > when was this mistake introduced. Is it a regression compared to what we
> > have in 2.6.26?
> 
> Again. think of global warming.

I fully get why we wanna fix that. That was not my questions. Is this a
regression compared to what we have in 2.6.26? Yes or no. A clear yes
make this a regression and we will not even discuss this any further.
That patch should go in then. In the no case you have to come up with
some good argument.

Remember that I reviewed all patches under the strict after merge window
rules. There is always a gray area, but please give good argumentation
for it in the commit message.

And again, if I would be in Dave shoes, I would reject this one.

Also it would be a bad idea to just keep sending patches and then have
John forward them to Dave. At some point this backfires. Just split
these up into 2.6.27 and 2.6.28 patches and give them to John.

Regards

Marcel


