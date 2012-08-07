Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2HGKem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 06:34:42 -0400
Date: Tue, 7 Aug 2012 12:34:34 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC] [PATCHv2] rt2x00: specify iface_combinations to allow for
 multi-bss operation
Message-ID: <20120807103433.GB12589@redhat.com> (sfid-20120807_123445_878711_F2099379)
References: <CAL1gcdM4-mbdDTmopEhZhHysVioxP5+E=DuMRDU_nLxmebN8Nw@mail.gmail.com>
 <1344243790-30164-1-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1344243790-30164-1-git-send-email-fercerpav@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 06, 2012 at 01:03:10PM +0400, Paul Fertser wrote:
> However, real-life testing on RT3052F SoC showed that neither WPA-PSK +
> Open nor 2 WPA-PSK APs work properly (though both APs beacon properly).
> No other tests were performed.

You can try to use nohwcrypt option. If you configure 2 open APs, does
this work?

Stanislaw
