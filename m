Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab0DPN5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 09:57:15 -0400
Date: Fri, 16 Apr 2010 15:59:07 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath5k: Use high bitrates for ACK/CTS
Message-ID: <20100416155907.6e33c722@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20100412073847.28215.87571.stgit@tt-desk>
References: <20100412073847.28215.87571.stgit@tt-desk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 12 Apr 2010 16:38:47 +0900
Bruno Randolf <br1@einfach.org> wrote:

> There was a confusion in the usage of the bits AR5K_STA_ID1_ACKCTS_6MB and
> AR5K_STA_ID1_BASE_RATE_11B. If they are set (1), we will get lower bitrates for
> ACK and CTS. Therefore ath5k_hw_set_ack_bitrate_high(ah, false) actually
> resulted in high bitrates, which i think is what we want anyways. Cleared the
> confusion and added some documentation.

I thought ACK and other control frames have to be modulated at slow/robust
bitrates, but can't remember where I read that ...

Stanislaw
