Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56803.mail.re3.yahoo.com ([66.196.97.77]:22936 "HELO
	web56803.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759222Ab0J2U0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 16:26:44 -0400
Message-ID: <694082.86488.qm@web56803.mail.re3.yahoo.com>
Date: Fri, 29 Oct 2010 13:26:43 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Realtek rtl8188 support?
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <201010292202.25486.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> With both devices the connection is stable and quite
> performant (~9 MB/s, 
> short distance, little channel overlap) against an Atheros/
> athk9 based 
> router running OpenWrt (HT20 && HT40-, b/g/n). In
> comparison to rtl8192su
> the authentification handshake succeeds a lot quicker and
> without needing 
> retries, performance is comparable.

Now, that we're in the habit of adding staging drivers to compat-wireless, shouldn't this one follow the likes of ath6kl and brcm80211? Surely lots of users will benefit from this.

Walter


      
