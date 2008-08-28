Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40143 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYH1MCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:02:11 -0400
Subject: Re: [PATCH 09/11] iwlwifi: fix station mimo power save values
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240808280411l4b229cfdnbcb24b3ad5cae1cd@mail.gmail.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-9-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-10-git-send-email-yi.zhu@intel.com>
	 <1219927236.6064.27.camel@californication>
	 <1ba2fa240808280411l4b229cfdnbcb24b3ad5cae1cd@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 16:02:08 +0200
Message-Id: <1219932128.6064.57.camel@californication> (sfid-20080828_140214_935660_EA612DE6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> This patch fixes the wrong use of self mimo power save values instead of
> >> peer's mimo power save values.
> >
> > please state the impact of not fixing this. When does this matter. Does
> > the both sides have to enable this feature and things like this.
> 
> Okay, we might not be able to do any traffic to the [peer station
> because by mistake we configured TX to according our RX capability not
> RX capability of the peer station.

that would have been a good addition to the commit message. That the
result of this issue is no TX, belongs in it.

Regards

Marcel


