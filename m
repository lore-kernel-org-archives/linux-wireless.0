Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:44734 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab1JQO1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 10:27:33 -0400
Date: Mon, 17 Oct 2011 16:27:27 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Woodhouse <dwmw2@infradead.org>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 3.2 REQUEST] b43: HT-PHY: report signal to mac80211
Message-ID: <20111017162727.388624fc@milhouse> (sfid-20111017_162736_674563_4740EF3F)
In-Reply-To: <1318800649-5609-1-git-send-email-zajec5@gmail.com>
References: <1318800649-5609-1-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 16 Oct 2011 23:30:49 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:
> +	case B43_PHYTYPE_HT:
> +		/* TODO: is max the right choice? */
> +		status.signal = max(
> +			(__s8) max(rxhdr->phy_ht_power0, rxhdr->phy_ht_power1),

Hm, why is this cast needed? Does it throw a warning?

-- 
Greetings, Michael.
