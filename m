Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37535 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYH1L5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:57:52 -0400
Subject: Re: [PATCH 02/11] iwlwifi: use mac80211 band and channel settings
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240808280432w2c4360b4mc173a2bab75a94ce@mail.gmail.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219926478.6064.9.camel@californication>
	 <1ba2fa240808280432w2c4360b4mc173a2bab75a94ce@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 15:57:49 +0200
Message-Id: <1219931869.6064.51.camel@californication> (sfid-20080828_135754_831161_7342877E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> This patch makes use of mac80211 defaults for channel and band settings
> >> instead of setting them by the driver own. The iwlwifi driver used to
> >> set G band channel 6 as the default channel.
> >
> > that is not a regression. The driver has been doing this until now and
> > thus it can keep doing it until the next merge window.
> >
> > If you disagree, then please explain the regression in the commit
> > message.
> 
> It's trashing initial configuration as two different configuration
> were applied in the initial flow. Frankly I don't remember what bug we
> had this with. Maybe it's not so urgent.

if it is not worse than what we had in 2.6.26, then it should clearly
wait. I fail to see how it could be a regression, but you are the expert
with this hardware.

Regards

Marcel


