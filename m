Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:35497 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab3FKDlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 23:41:36 -0400
Date: Mon, 10 Jun 2013 21:41:34 -0600
From: Jake Edge <jake@lwn.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT/RFC 0/4] iwlegacy: workaround for firmware frame tx
 rejection
Message-ID: <20130610214134.36085c4b@chukar.edge2.net> (sfid-20130611_054152_246938_416DADA6)
In-Reply-To: <20130610143848.7afd5acc@chukar.edge2.net>
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
	<20130610143848.7afd5acc@chukar.edge2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 10 Jun 2013 14:38:48 -0600 Jake Edge wrote:

> > Please apply it together with this mac80211 patch:
> > http://marc.info/?l=linux-wireless&m=136879090123023&w=2 
> > which I already posted and is queued to upstream. Not having
> > it may cause troubles and influence negatively this set test.
> 
> I tried it on both 3.9 (without 4/4 since it doesn't have that
> workaround in it) and on 3.10-rc4 and in both cases, i get the same
> behavior: it tries to connect many times and fails, then eventually
> connects (after like 20 tries from KDE network manager) ...

actually, i spoke too soon, the 3.10-rc4 has not been able to connect
at all, after many hours of trying.  I manually went in and selected
the other 2.4GHz SSID (rather than the 5GHz it had been trying) and it
connected right away, fwiw ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
