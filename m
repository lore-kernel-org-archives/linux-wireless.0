Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60920 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYH1MMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:12:42 -0400
Subject: Re: [PATCH 07/11] iwlwifi: generic init calibrations framework
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240808280420i21b7390bufeec5d8819e2723@mail.gmail.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219926977.6064.21.camel@californication>
	 <1ba2fa240808280420i21b7390bufeec5d8819e2723@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 16:12:39 +0200
Message-Id: <1219932759.6064.69.camel@californication> (sfid-20080828_141246_088296_C3D4E53E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> This patch fixes a critical bug that only the last calibration result
> >> was applied. On reception of one calibration result all the calibration
> >> was freed. The patch fixes this problem by introducing a generic init
> >> calibration framework which allows variable number of init calibrations
> >> and allows addition new HW.
> >
> > a lot of code changes in -rc4 phase. Please give more details since the
> > patch changes a lot and even introduces a new EXPORT.
> 
> The first sentence is important, the whole framework was buggy.

I got that part, but understand that just changing a framework at the
state of -rc4 is never a good idea. Any possible regression that might
come out of it, could delay the release.

In this case it would actually help to have clear Reviewed-by or
Tested-by statements in the patch. Signed-off only states the authors
and doesn't give this change more credit.

Regards

Marcel


