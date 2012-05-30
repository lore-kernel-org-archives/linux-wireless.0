Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2E3VFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 17:05:42 -0400
Date: Wed, 30 May 2012 16:05:38 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>
Subject: Re: brcmsmac connection stalls (was Re: )
Message-ID: <20120530210538.GG30697@thinkpad-t410> (sfid-20120530_230546_565371_97C7F335)
References: <20120530202547.GE30697@thinkpad-t410>
 <4FC687C1.6090800@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC687C1.6090800@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 30, 2012 at 10:49:05PM +0200, Arend van Spriel wrote:
> If you can provide me as much detail as possible on the AP settings I
> can dive into it over here.

The AP is a Linksys E3000 running dd-wrt. Here's what iw says about it.
Let me know if there's any more information you'd like to have or
anything else I can do to help.

        TSF: 80992461200 usec (0d, 22:29:52)
        freq: 2412
        beacon interval: 100
        capability: ESS Privacy ShortSlotTime (0x0411)
        signal: -35.00 dBm
        last seen: 10192 ms ago
        Information elements from Probe Response frame:
        SSID: Kailia
        Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
        DS Parameter set: channel 1
        ERP: <no flags>
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 16-PTKSA-RC (0x000c)
        Extended supported rates: 6.0 9.0 12.0 48.0 
        HT capabilities:
                Capabilities: 0x187e
                        HT20/HT40
                        SM Power Save disabled
                        RX Greenfield
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15, 32
                HT TX MCS rate indexes are undefined
        HT operation:
                 * primary channel: 1
                 * secondary channel offset: above
                 * STA channel width: any
                 * RIFS: 1
                 * HT protection: nonmember
                 * non-GF present: 0
                 * OBSS non-GF present: 1
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec

