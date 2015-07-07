Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server14-mail.hostwhitelabel.com ([104.152.168.114]:48382 "EHLO
	server14.hostwhitelabel.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932511AbbGGRmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 13:42:38 -0400
From: CACook@quantum-sci.com
To: ath10k@lists.infradead.org
Cc: Peter Oh <poh@qca.qualcomm.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k: add support for qca99x0 Rx descriptors
Date: Tue, 07 Jul 2015 10:09:38 -0700
Message-ID: <2345251.lpvZM96hbt@andromeda> (sfid-20150707_194244_828088_3930D6E3)
In-Reply-To: <1436287676-25767-4-git-send-email-poh@qca.qualcomm.com>
References: <1436287676-25767-1-git-send-email-poh@qca.qualcomm.com> <1436287676-25767-4-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 07 July 2015 9:47:56 Peter Oh wrote:
> QCA99X0 chip has an extra 4 bytes in rx_msdu_start,
> 20 bytes in rx_msdu_end and 20 bytes in rx_ppdu_end structure
> which are used in htt_rx_desc and HTT Rx ring offset setup.
> This is necessary for correct Rx for QCA99X0 or Rx descriptors
> will be overwritten and corrupted.

Will this be in the most recent git, to support the QCA9880?


