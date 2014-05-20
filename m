Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38877 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaETOaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 10:30:14 -0400
Date: Tue, 20 May 2014 10:24:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
Message-ID: <20140520142453.GB13981@tuxdriver.com> (sfid-20140520_163021_237489_C57542FF)
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
 <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 12:33:51AM -0700, Luis R. Rodriguez wrote:
> On Fri, May 9, 2014 at 1:40 AM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
> > Introduce support for setting DFS CAC time
> > in milliseconds.
> >
> > Eg.
> > (5250 - 5330 @ AUTO), (20), (60000), DFS
> >
> > will setup CAC 60 seconds CAC time.
> 
> Can you elaborate whether or not this will require a bump on CRDA  and
> issuing of two new wireless-regdb files for the different versions on
> the commit log?

I would really prefer not to manage two regdb binary releases.
Fear of that is what has kept me from merging this patch.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
