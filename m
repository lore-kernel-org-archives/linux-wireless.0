Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37976 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaETSY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 14:24:58 -0400
Message-ID: <1400610273.4474.6.camel@jlt4.sipsolutions.net> (sfid-20140520_202501_013531_F1DDC756)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 20 May 2014 20:24:33 +0200
In-Reply-To: <20140520180832.GD13981@tuxdriver.com> (sfid-20140520_201518_644762_1B148A19)
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
	 <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
	 <20140520142453.GB13981@tuxdriver.com>
	 <CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>
	 <20140520180832.GD13981@tuxdriver.com>
	 (sfid-20140520_201518_644762_1B148A19)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-20 at 14:08 -0400, John W. Linville wrote:

> > I can add support for version 19 and 20 in one crda. I am not sure
> > this is the best option.
> > BTW what about versions < 19? How do we handle this this days?
> 
> What about older CRDA with newer wireless-regdb?  Do we need to worry about that?

I think we should, but if we can't then at least can we cut to an
extensible format?

(and yeah, I know I was part of defining the format ...)

johannes

