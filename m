Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56181 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaFJQpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 12:45:50 -0400
Message-ID: <1402418724.4152.3.camel@jlt4.sipsolutions.net> (sfid-20140610_184601_398167_D61FF18F)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 10 Jun 2014 18:45:24 +0200
In-Reply-To: <CALhHN=qZuPMjQMWGf0+J0ZKnj=5EGtfC=nWjJAYj2YWu=TTYLg@mail.gmail.com> (sfid-20140609_093354_496554_75DBC341)
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
	 <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
	 <20140520142453.GB13981@tuxdriver.com>
	 <CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>
	 <20140520180832.GD13981@tuxdriver.com>
	 <1400610273.4474.6.camel@jlt4.sipsolutions.net>
	 <CAB=NE6WiuydxR62dvua_OEyV+sqxvH8aOUHOBLS3ePz1dGCLAw@mail.gmail.com>
	 <1400688233.4136.8.camel@jlt4.sipsolutions.net>
	 <20140521180020.GA13656@tuxdriver.com>
	 <1400699356.4136.13.camel@jlt4.sipsolutions.net>
	 <CALhHN=qZuPMjQMWGf0+J0ZKnj=5EGtfC=nWjJAYj2YWu=TTYLg@mail.gmail.com>
	 (sfid-20140609_093354_496554_75DBC341)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-06-09 at 09:33 +0200, Janusz Dziedzic wrote:

> Why not just skip this binary interface between regdb --> crda and use
> signed db.txt file?

I fail to see how that's any better? If anything, it seems to me that it
would be *harder* to keep the database text format parseable to old CRDA
versions when making changes.

johannes

