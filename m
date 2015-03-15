Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37540 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbCOCfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 22:35:38 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21764.61660.411242.223378@gargle.gargle.HOWL> (sfid-20150315_033556_171366_33C9EE44)
Date: Sun, 15 Mar 2015 08:09:24 +0530
To: Saurabh Pal <saurabh6321@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [ath9k-devel] ath9k channel switch
In-Reply-To: <CAGrUaU24vCH6+GpAtBCNiGwdT4_-FNNLDq=_s5zhSPBOp8bbmg@mail.gmail.com>
References: <CAGrUaU24vCH6+GpAtBCNiGwdT4_-FNNLDq=_s5zhSPBOp8bbmg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Saurabh Pal wrote:
> Just wanted to know whether it is possible to switch the channel without
> resetting the chip. Also if possible can anybody tell me how much time it
> takes to switch the channel by resetting the chip?

Fast Channel Change is used to switch channels without a full chip reset.
The time taken to switch channels is not exported, but you can measure it
in the driver.

Sujith
