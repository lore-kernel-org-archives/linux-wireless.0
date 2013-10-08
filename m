Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:37791 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756964Ab3JHKo6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 06:44:58 -0400
Date: Tue, 8 Oct 2013 12:46:20 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Kevin Lo <kevlo@kevlo.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2] rt2x00: rt2800lib: no need to toggle
 RF R30 bit 7 twice
Message-ID: <20131008104620.GA15764@localhost.localdomain> (sfid-20131008_124522_224833_92B8FB3B)
References: <525269F0.5000802@kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <525269F0.5000802@kevlo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 07, 2013 at 03:59:44PM +0800, Kevin Lo wrote:
>         rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
>         rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET,
> rt2x00dev->freq_offset);
>         rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);

NACK, still malformed
