Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43487 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbaJHOuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 10:50:21 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21557.20300.648468.965143@gargle.gargle.HOWL> (sfid-20141008_165028_159743_59C655F8)
Date: Wed, 8 Oct 2014 20:20:52 +0530
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Okhwan Lee <ohlee@mwnl.snu.ac.kr>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: How to know the information about RTS reception in mac80211 or
 device driver
In-Reply-To: <CA+BoTQkvUkdkWDLOzu2cz6C6SGWFL2SCgwMDLf=ruaFwP9umjg@mail.gmail.com>
References: <etPan.5433ced3.74b0dc51.2d48@Mac-Pro.local>
	<CA+BoTQkvUkdkWDLOzu2cz6C6SGWFL2SCgwMDLf=ruaFwP9umjg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior wrote:
> I think you've just found an ath10k bug.
> 
> I've been running through Rx code lately. I was looking at
> htt_rx_mpdu_status and noticed it was a bit greedy. I then recalled
> someone was complaining about RTS reception.

Maybe the RX filter to receive control frames is not set properly in the FW ?
ath10k doesn't seem to use WMI_10X_PDEV_PARAM_RX_FILTER.

Sujith
