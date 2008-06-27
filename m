Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4861 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759275AbYF0RrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 13:47:03 -0400
Date: Fri, 27 Jun 2008 13:15:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: drago01 <drago01@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-06-27
Message-ID: <20080627171524.GC20277@tuxdriver.com> (sfid-20080627_194714_422650_F547174E)
References: <20080627153541.GA16597@tuxdriver.com> <f6ca9fed0806270854u674a9d5aled463865e07829c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0806270854u674a9d5aled463865e07829c8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 27, 2008 at 05:54:06PM +0200, drago01 wrote:
> On Fri, Jun 27, 2008 at 5:35 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> 
> > Randy Dunlap (1):
> >      iwlwifi: fix build for CONFIG_INPUT=n
> 
> this one was NACKED by Ivo (well not exactly this but the 3945
> version, and Yi posted an updated patch)

That merged patch appears to be identical to the one in this thread:

	http://marc.info/?l=linux-next&m=121436670630784&w=2

That includes an ACK for Zhu Yi.  Am I missing something?

John
-- 
John W. Linville
linville@tuxdriver.com
