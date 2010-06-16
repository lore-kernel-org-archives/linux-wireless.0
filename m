Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:31310 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab0FPFb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 01:31:58 -0400
Subject: Re: [PATCH v2] iw: Configure basic rates when joining ibss network
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276596357.3648.91.camel@jlt3.sipsolutions.net>
References: <1276595169-3669-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276596357.3648.91.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Wed, 16 Jun 2010 08:31:03 +0300
Message-Id: <1276666263.4314.39.camel@paavo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 12:05 +0200, ext Johannes Berg wrote:
> On Tue, 2010-06-15 at 12:46 +0300, Teemu Paasikivi wrote:
> 
> > +	/* basic rates */
> > +	if (argc > 1 && strcmp(argv[0], "basic-rates") == 0) {
> 
> >  	if (argc) {
> 
> > +COMMAND(ibss, join,
> > +	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] "
> > +	"[basic-rates <rate in Mbps,rate2,...>] [key d:0:abcde]",
> 
> that doesn't match?
> 

No it doesn't. Have to fix that (and look at the mirror).


> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Teemu


