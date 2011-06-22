Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm30.bullet.mail.bf1.yahoo.com ([98.139.212.189]:22257 "HELO
	nm30.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757913Ab1FVNln convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 09:41:43 -0400
References: <loom.20110621T215346-191@post.gmane.org> <BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>
Message-ID: <1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com> (sfid-20110622_154146_913504_76736765)
Date: Wed, 22 Jun 2011 06:41:42 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: Performance regression between Madwifi/net80211 and ath5k/mac80211
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian,
thanks for taking an interest. Today I built the current Madwifi driver for
Fedora Kernel 2.6.38.8-32.fc15.i686. The ath5k problem seems to be at the
tx side. If I run the iperf server on the ath5k node and the iperf client
at the madwifi node (identical hardware config), I consistently get a 
significant
speedup compared to ath5k-ath5k. The only difference is, which module is
blacklisted.

I have experimented with the RTS and fragmentation threshold setting without
success. 

Now I'm somewhat lost. The problem is either ath5k or mac80211. 

-- 
Regards 
Joerg 




----- Orifinal Mail ----
> Von: Adrian Chadd <adrian@freebsd.org>
> An: jpo <pommnitz@yahoo.com>
> CC: linux-wireless@vger.kernel.org
> Gesendet: Mittwoch, den 22. Juni 2011, 4:17:05 Uhr
> Betreff: Re: Performance regression between Madwifi/net80211 and 
ath5k/mac80211
> 
> Have you eliminated the kernel version as being the  problem?
> 
> 
> Adrian
