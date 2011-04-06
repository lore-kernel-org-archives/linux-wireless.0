Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab1DFSzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 14:55:03 -0400
Subject: Re: new maintenance release of iwlwifi 1000 uCode available
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTi=mrU7mgiB=E6tJN1Z1Qz_g8RdEUw@mail.gmail.com>
References: <1301945671.14995.110.camel@wwguy-huron>
	 <20110406141258.GA11941@tuxdriver.com>
	 <1302099870.4090.3.camel@jlt3.sipsolutions.net>
	 <20110406142711.GB11941@tuxdriver.com>
	 <1302099854.14995.115.camel@wwguy-huron>
	 <BANLkTi=mrU7mgiB=E6tJN1Z1Qz_g8RdEUw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 20:55:00 +0200
Message-ID: <1302116100.4090.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-06 at 20:49 +0200, Gábor Stefanik wrote:

> >> OK, I can cope.  But if you (i.e. your team) can influence them
> >> towards a sane numbering scheme, it will probably make packagers
> >> and/or release engineers happier in the distros...

> Perhaps formatting the number as "3.1.128.50" and "5.1.39.31" would be
> a saner idea.

It still wouldn't be monotonically increasing ... you could have
5.1.39.31 and then 5.1.17.168 since the API version doesn't necessarily
change all the time.

johannes

