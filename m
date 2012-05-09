Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34932 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2EISK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 14:10:58 -0400
Message-ID: <1336587054.1121.2.camel@jlt3.sipsolutions.net> (sfid-20120509_201102_285698_F4B583A0)
Subject: Re: brcmsmac still woes, possible regression?
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	=?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>
Date: Wed, 09 May 2012 20:10:54 +0200
In-Reply-To: <4FAAB0FE.601@broadcom.com>
References: <20120328112657.GA6114@stt008.linux.site>
	 <4F7302D9.8070009@broadcom.com>
	 <CAKprTDHz0d=W1472KcHuD-Zda9dCUX+5nKfEX55UfiNBeQ7T2w@mail.gmail.com>
	 <4F744DD8.8010004@broadcom.com> <20120329133835.GA5196@stt008.linux.site>
	 <CAKprTDFxqYq7jMm3z19xEt4NBeN9FbcR0pez9BSjY6R8kZC5KA@mail.gmail.com>
	 <20120402215005.GA13969@burratino> <4F7B179F.7070502@broadcom.com>
	 <20120509094111.GA2333@burratino> <4FAA45AF.8050201@broadcom.com>
	 <20120509174106.GA7189@ubuntu-mba> <4FAAB0FE.601@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-09 at 20:01 +0200, Arend van Spriel wrote:

> As part of the discussion over here I am proposing to get rid of the tx
> muting in brcmsmac as mac80211 already has that behaviour for passive
> channels if I am not mistaken (is this true, Johannes?).

Arend, I haven't really followed this discussion, can you elaborate?

On passive channels, when scanning, mac80211 will send a probe only
after receiving a frame on that channel. When associating, it has no
such behaviour, at least not directly, but I suppose it could be
implemented (waiting for the beacon)

johannes

