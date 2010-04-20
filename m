Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:11626
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753892Ab0DTLfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 07:35:09 -0400
Date: Tue, 20 Apr 2010 13:35:05 +0200
From: Johan Hovold <johan.hovold@lundinova.se>
To: Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Cc: Johan Hovold <johan.hovold@lundinova.se>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: corrupt frames forwarded to mac80211 as
 decrypted
Message-ID: <20100420113505.GJ5288@lundinova.se>
References: <20100331191058.GD18913@lundinova.se>
 <20100416104850.GA13329@lundinova.se>
 <20100420082519.GB5288@lundinova.se>
 <1271754651.14253.112.camel@ranga-desktop>
 <20100420110657.GH5288@lundinova.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100420110657.GH5288@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 20, 2010 at 01:06:57PM +0200, Johan Hovold wrote:
> On Tue, Apr 20, 2010 at 02:40:51PM +0530, Ranga Rao Ravuri wrote:
> > Can you please set register 0x8120 bit 28 to 1 and test this again to
> > see that helps ?
> 
> I'll try that.

I'm afraid it does not seem to have any effect on the corrupt frame
status.

Anything else I can try?

Thanks,
Johan

