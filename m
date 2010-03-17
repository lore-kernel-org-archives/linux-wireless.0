Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44751 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab0CQNCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 09:02:23 -0400
Date: Wed, 17 Mar 2010 09:01:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] wireless: convert reg_regdb_search_lock to mutex
Message-ID: <20100317130101.GB2990@tuxdriver.com>
References: <4B9F86E9.2030702@gmail.com> <1268768940-5654-1-git-send-email-linville@tuxdriver.com> <20100316100337.GA1732@senthil-lnx.users.atheros.com> <20100317002416.GA2095@tuxdriver.com> <20100316122449.GA17826@senthil-lnx.users.atheros.com> <20100317025656.GA9058@tuxdriver.com> <1268796275.7068.8.camel@jlt3.sipsolutions.net> <20100317125513.GA2990@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100317125513.GA2990@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 17, 2010 at 08:55:13AM -0400, John W. Linville wrote:
> On Tue, Mar 16, 2010 at 08:24:35PM -0700, Johannes Berg wrote:

> > English at work ... let me guess:
> > 
> > For John: "can" == "it could happen that"
> > For Senthil: "can" == "may"
> > 
> > (when really you may NOT do GFP_KERNEL allocations in atomic context)
> 
> Ah, that seems like a plausible explanation for the confusion.
> Bitte mein herr!

Err...danke mein herr! :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
