Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56189 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaFJQqo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 12:46:44 -0400
Message-ID: <1402418780.4152.4.camel@jlt4.sipsolutions.net> (sfid-20140610_184647_408049_B072E340)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 10 Jun 2014 18:46:20 +0200
In-Reply-To: <53956986.8070603@openwrt.org>
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
		 <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
		 <20140520142453.GB13981@tuxdriver.com>
		 <CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>
		 <20140520180832.GD13981@tuxdriver.com>
		 <1400610273.4474.6.camel@jlt4.sipsolutions.net>
		 <CAB=NE6WiuydxR62dvua_OEyV+sqxvH8aOUHOBLS3ePz1dGCLAw@mail.gmail.com>
		 (sfid-20140520_204832_656990_FF6AC676) <1400688233.4136.8.camel@jlt4.sipsolutions.net>
	 <53956986.8070603@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-06-09 at 10:00 +0200, Felix Fietkau wrote:

> > Looks like the format update really is needed, which probably means we
> > should change the scripts to generate two databases and change the
> > filename, or so?

> How about making the format properly extensible by reusing what we're
> already doing to keep the kernel ABI stable? For example, we could store
> the database in a netlink-like attribute format, with some changes to
> make it fixed endian.
> I'm already doing just that for a few things in OpenWrt, so I have
> working C code for writing and parsing such a format.
> 
> Another nice feature would be to indicate in the attributes if crda is
> required to understand them, or if it can just continue with a warning.
> 
> If done right, I think we can probably make this the last time we change
> the format version.

Sure, that seems like a more detailed version of email :)
I don't really care about the low-level details that much.

johannes

