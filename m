Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49579 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030897Ab2HIPWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 11:22:21 -0400
Received: by eeil10 with SMTP id l10so205264eei.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 08:22:20 -0700 (PDT)
Date: Thu, 9 Aug 2012 19:22:17 +0400
From: Paul Fertser <fercerpav@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC] [PATCHv2] rt2x00: specify iface_combinations to allow
	for multi-bss operation
Message-ID: <20120809152217.GR28444@home.lan> (sfid-20120809_172230_610443_85237E66)
References: <CAL1gcdM4-mbdDTmopEhZhHysVioxP5+E=DuMRDU_nLxmebN8Nw@mail.gmail.com> <1344243790-30164-1-git-send-email-fercerpav@gmail.com> <20120807103433.GB12589@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120807103433.GB12589@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 07, 2012 at 12:34:34PM +0200, Stanislaw Gruszka wrote:
> On Mon, Aug 06, 2012 at 01:03:10PM +0400, Paul Fertser wrote:
> > However, real-life testing on RT3052F SoC showed that neither WPA-PSK +
> > Open nor 2 WPA-PSK APs work properly (though both APs beacon properly).
> > No other tests were performed.
> 
> You can try to use nohwcrypt option. If you configure 2 open APs, does
> this work?

Should have tried that indeed, silly me. But, heh, surprise, neither
of that works for me, i always get
"wlan0: STA 6c:62:6d:17:b9:3a IEEE 802.11: did not acknowledge
authentication response" in the log on the AP side.

I can try to capture over-the-air log, but i'm not sure if that's
needed since i can't fix the driver myself and the issue looks like an
easily reproducible one.

TIA
-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
