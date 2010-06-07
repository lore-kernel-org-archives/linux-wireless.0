Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:45973 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756057Ab0FGDpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 23:45:30 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0154102325
	for <linux-wireless@vger.kernel.org>; Mon,  7 Jun 2010 12:45:28 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna configuration
Date: Mon, 7 Jun 2010 12:45:37 +0900
References: <20100519012528.22206.77550.stgit@tt-desk> <20100604193009.GD2492@tuxdriver.com> <20100604212145.GB4069@tux>
In-Reply-To: <20100604212145.GB4069@tux>
Cc: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006071245.37159.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 June 2010 06:21:45 you wrote:
> I don't think the API is defined clean enough yet and can yield
> inconsistant interpretations. I'd like to see this clarified on
> the documentation for both legacy and 802.11n. If the plan is
> to support only legacy right now then I think the API can be
> simpler and clearer with only three options passed, Fixed_A
> Fixed_B and diversity.

luis, i thought we had this resolved during the last thread... i gave you  
examples why fixed_a, fixed_b and diversity is not enough. 

anyhow, there are a few places where i have to make the definition clearer in 
order to avoid inconsistent interpretations, that's right. i will resend this 
so we can continue any discussions based on that. 

john, i will resend the rest of the series, the ath5k part and the antenna 
configuration as separate series. sorry for mixing that up before...

bruno
