Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:53568
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955Ab3ACJ0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 04:26:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20709.20104.77507.315148@gargle.gargle.HOWL> (sfid-20130103_102627_063302_5C0D7EE6)
Date: Thu, 3 Jan 2013 14:55:28 +0530
To: Schrober <franzschrober@yahoo.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] ath9k_hw: Fix calibration for AR9340
In-Reply-To: <1544381.2zNlvhsdEP@bentobox>
References: <1357195883-8516-1-git-send-email-sujith@msujith.org>
	<1357195883-8516-2-git-send-email-sujith@msujith.org>
	<1544381.2zNlvhsdEP@bentobox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Schrober wrote:
> On Thursday 03 January 2013 12:21:22 Sujith Manoharan wrote:
> > From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> > 
> > TX_IQ_ON_AGC_CAL should not be enabled for AR9340.
> 
> Why?

Because the chip doesn't support it.

Sujith
