Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36385 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750806AbXLDSdK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 13:33:10 -0500
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071204185719.2eba303c@morte>
References: <1196622331.7472.4.camel@localhost>
	 <20071203041608.3af3b462@morte> <1196679780.7470.9.camel@localhost>
	 <20071203125402.76562f26@morte> <1196683144.7470.14.camel@localhost>
	 <20071203130602.49ab7234@morte>
	 <40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
	 <20071204024146.15689ee3@morte> <1196756103.7476.12.camel@localhost>
	 <20071204110135.1835a57e@morte> <1196790047.7472.5.camel@localhost>
	 <20071204185719.2eba303c@morte>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 19:33:06 +0100
Message-Id: <1196793186.7472.14.camel@localhost> (sfid-20071204_183323_253268_7B272663)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Please see Johannes's proposal [1]. I tend to agree with that. Here comes
> my plan: for testing, I'd say we can stick to those modparams I introduced
> last night, setting perms to 644 and just being careful to bring down the
> interface before changing them through sysfs. When we're done with testing,
> we can decide which parameters need to be exported and which don't, and
> then implement proper locking and exporting parameters through nl80211. Is
> this OK for you?

This is fine with me, let's go ahead with this approach. I'll do some
test runs tonight to further tune the parameters. I also intend to clean
up the code a little.

Mattias

