Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51408.mail.re2.yahoo.com ([206.190.38.187]:46991 "HELO
	web51408.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760813AbYBHJsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 04:48:22 -0500
Date: Fri, 8 Feb 2008 10:41:41 +0100 (CET)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <691967.85958.qm@web51408.mail.re2.yahoo.com> (sfid-20080208_094827_294640_38FCCE26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> I think we should simply allow setting the BSSID (SIOCSIWAP maybe?) on
> IBSS interfaces and punt this issue to userspace.

This is exactly what we did/do with a Madwifi based IBSS network. I would
miss this feature when we switch to ath5k. So if you are taking votes on 
this, you will get mine.

Regards
  Joerg


      Lesen Sie Ihre E-Mails jetzt einfach von unterwegs.
www.yahoo.de/go
