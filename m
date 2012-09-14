Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24488 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758675Ab2INJ0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 05:26:39 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20562.63507.607989.546536@gargle.gargle.HOWL> (sfid-20120914_112643_729886_75D4F6C0)
Date: Fri, 14 Sep 2012 14:55:39 +0530
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: Sujith Manoharan <c_manoha@qualcomm.com>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC 7/8] ath9k: Add a module parameter to enable diversity for
In-Reply-To: <CAD2nsn0paBt4YyyCp0-iuJ9xxQctRhdL+TtVh1bovM2WMt4MzQ@mail.gmail.com>
References: <20562.57519.298444.874991@gargle.gargle.HOWL>
	<CAD2nsn0paBt4YyyCp0-iuJ9xxQctRhdL+TtVh1bovM2WMt4MzQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi wrote:
> > +static int ath9k_enable_diversity;
> > +module_param_named(enable_diversity, ath9k_enable_diversity, int, 0444);
> > +MODULE_PARM_DESC(enable_diversity, "Enable Antenna diversity for AR9565");
> 
> is it specific for AR9565 alone, we have AR9285, AR9485 .

For AR9565 only, this is needed because we are sharing the BT antenna.

Sujith
