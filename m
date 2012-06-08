Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18989 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab2FHMRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 08:17:39 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20433.60690.664811.750413@gargle.gargle.HOWL> (sfid-20120608_141743_720184_9871F1DC)
Date: Fri, 8 Jun 2012 17:46:18 +0530
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <stable@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: Fix softlockup in AR9485
In-Reply-To: <4FC70737.1070708@qca.qualcomm.com>
References: <1338394222-10274-1-git-send-email-mohammed@qca.qualcomm.com>
	<20422.56106.127697.13731@gargle.gargle.HOWL>
	<4FC702E4.9000906@qca.qualcomm.com>
	<20423.1188.258292.959073@gargle.gargle.HOWL>
	<4FC70737.1070708@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> > HZ can be configured to a user-defined value, so we need to make sure
> > that the timing for the PLL work is what we want.
> 
> ok, then we will change it.

Shafi, will you be sending an updated version of this patch ?
AR9485 is unusable currently - just bringing up the interface is
enough to hang the machine...

Sujith
