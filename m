Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38099 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3BLAMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 19:12:43 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20761.34987.125000.908722@gargle.gargle.HOWL> (sfid-20130212_011247_263546_62B715AD)
Date: Tue, 12 Feb 2013 05:41:23 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
In-Reply-To: <511935F2.8080103@candelatech.com>
References: <511935F2.8080103@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> axq-qnum:                    2          3         1         0
> axq-depth:                   0          0         0         0
> axq-ampdu_depth:             0          0         0         0
> axq-stopped                  1          0         0         0
> tx-in-progress               0          0         0         0
> pending-frames             125          0         0         0

The frames appear to be stuck in the pending queue.

Sujith
