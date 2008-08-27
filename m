Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43770 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbYH0NLP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 09:11:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Date: Wed, 27 Aug 2008 15:10:34 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"David Miller" <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080827013009.GA15781@tuxdriver.com> <1219831828.3891.3.camel@johannes.berg> <1ba2fa240808270434y1589761xd2ff0a48c2e99033@mail.gmail.com>
In-Reply-To: <1ba2fa240808270434y1589761xd2ff0a48c2e99033@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808271510.35950.mb@bu3sch.de> (sfid-20080827_151121_347601_9ECDCADD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 27 August 2008, Tomas Winkler wrote:
> > should use Linux upstream as your development tree and then branch off
> > of that for the internal stabilisation trees you need for other
> > customers, rather than having some sort of internal development tree and
> > branching out Linux upstream as you appear to work.
> 
> Unfortunately fixing bugs on stable branch take precedence  of
> adjusting to new API on development branch that someone decided to do.
>  I wanted to work directly on wireless testing but it was broken over
> an over and I have only limited resources more in testing then in
> development I just had to branch out to be ready with the driver when
> HW is out. People just check the immediate impact of they fix the
> don't test for collateral damage and this is understandable an
> individual developer doesn't have lab with IBSS, BSS, AP, etc setups.

I think it would be an advantage for you to develop in wireless-testing
and use wireless-2.6 and probably additionally some internal trees as
stable trees. Like everybody else does it.

The advantage is simple: You get more people testing your code.
