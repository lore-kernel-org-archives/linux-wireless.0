Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:16510 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754850Ab0D0AI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 20:08:58 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-030146934
	for <linux-wireless@vger.kernel.org>; Tue, 27 Apr 2010 09:08:56 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] cfg80211: add ap isolation support
Date: Tue, 27 Apr 2010 09:09:30 +0900
References: <1272324216-73349-1-git-send-email-nbd@openwrt.org> <20100426232332.GA2079@tuxdriver.com>
In-Reply-To: <20100426232332.GA2079@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004270909.30316.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 April 2010 08:23:33 you wrote:
> On Tue, Apr 27, 2010 at 01:23:35AM +0200, Felix Fietkau wrote:
> > This is used to configure APs to not bridge traffic between connected
> > stations.
> > 
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> Is this useful?

oh, yes! especially when you set up hotspots for internet access only.

bruno
