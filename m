Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kwall.cngroup.cz ([194.213.192.9]:25021 "EHLO kwall.cngroup.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab1KXND5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 08:03:57 -0500
Date: Thu, 24 Nov 2011 14:03:50 +0100
From: Jan =?UTF-8?B?RHZvxZnDoWs=?= <dvorakj@cngroup.dk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu not working with Edimax EW-7811Un
Message-Id: <20111124140350.06e9644056a9b4993bc093cb@cngroup.dk> (sfid-20111124_140400_335815_79C471E1)
In-Reply-To: <4ECD3E5E.6010109@lwfinger.net>
References: <20111122113427.3d332b00776546d5ebac11de@cngroup.dk>
	<20111122140139.GA3891@redhat.com>
	<20111123112301.f5e523ff743f86dae539fdf3@cngroup.dk>
	<20111123143304.GA13460@redhat.com>
	<20111123162426.9a30d25585fa54507c1c864e@cngroup.dk>
	<4ECD13D0.6010500@lwfinger.net>
	<20111123155108.GD13460@redhat.com>
	<20111123175210.fd0ac6b0b66885b3deaecfc0@cngroup.dk>
	<4ECD3E5E.6010109@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 23 Nov 2011 12:41:34 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:
> >>> I can't still use hostapd, however.
> >> Hmm, I'm not sure if rtl92c works in AP mode, Larry?
> 
> When I try it, I get rtl8192cu to beacon, and it is possible to authenticate and 
> associate, but the second computer never gets an IP number.

Even without DHCP, no traffic ever comes through. Plus from here it looks like
the client is reconnecting (quickly, let's say once per 5s) to no end.

So, how do I debug this properly? Can I turn on some kind of verbose mode?
Is there a way to sniff the communication (kismet or something)?

Best regards,
	Jan Dvorak
