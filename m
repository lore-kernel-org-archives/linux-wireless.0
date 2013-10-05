Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:15992 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3JEO7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Oct 2013 10:59:53 -0400
Date: Sat, 5 Oct 2013 17:01:16 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Kevin Lo <kevlo@kevlo.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800lib: no need to toggle RF
 R30 bit 7 twice
Message-ID: <20131005150116.GA30009@localhost.localdomain> (sfid-20131005_170002_716635_ADC6E172)
References: <525023D4.6000801@kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <525023D4.6000801@kevlo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 05, 2013 at 10:36:04PM +0800, Kevin Lo wrote:
>         rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
>         rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET,
> rt2x00dev->freq_offset);

Your mail client malformed the patch here, otherwise it looks ok.

Stanislaw
