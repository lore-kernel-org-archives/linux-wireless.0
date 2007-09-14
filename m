Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38181 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbXINVw0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 17:52:26 -0400
Date: Fri, 14 Sep 2007 14:52:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] list.h: add list_for_each_entry_continue_rcu
Message-ID: <20070914215221.GH9393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1189425947.4506.78.camel@johannes.berg> <20070910173948.GD11801@linux.vnet.ibm.com> <1189804498.3974.57.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1189804498.3974.57.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 14, 2007 at 11:14:58PM +0200, Johannes Berg wrote:
> On Mon, 2007-09-10 at 10:39 -0700, Paul E. McKenney wrote:
> > On Mon, Sep 10, 2007 at 02:05:47PM +0200, Johannes Berg wrote:
> > > To implement the multicast list callback in mac80211 we need to
> > > do partial list iteration. Since I want to convert the interface
> > > list to an RCU list, I need a new list walking primitive:
> > > list_for_each_entry_continue_rcu().
> 
> Hah. Turns out if I do the right thing with dev_mc_sync() I no longer
> need this. Paul, do you want to push it to akpm or such? My bugfix no
> longer relies on it.

OK, will push it when I convert list_for_each_continue_rcu().

						Thanx, Paul
