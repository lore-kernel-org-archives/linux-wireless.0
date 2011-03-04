Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48245 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759941Ab1CDVju (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 16:39:50 -0500
Date: Fri, 4 Mar 2011 13:37:13 -0800
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Mohammed Shafi <mshajakhan@atheros.com>,
	Mohammed Shajakhan <Mohammed.Shajakhan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	stable@kernel.org, Luis Rodriguez <Luis.Rodriguez@atheros.com>
Subject: Re: [stable] [RFC] ath9k: Fix ath9k prevents CPU to enter C3 states
Message-ID: <20110304213713.GA31324@kroah.com>
References: <1297785572-27955-1-git-send-email-mshajakhan@atheros.com>
 <20110215161222.GD2557@tuxdriver.com>
 <4D5B5B02.4020101@atheros.com>
 <4D70816D.80304@atheros.com>
 <20110304133722.GA9866@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110304133722.GA9866@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 04, 2011 at 08:37:23AM -0500, John W. Linville wrote:
> On Fri, Mar 04, 2011 at 11:36:37AM +0530, Mohammed Shafi wrote:
> > On Wednesday 16 February 2011 10:35 AM, Mohammed Shafi wrote:
> > >On Tuesday 15 February 2011 09:42 PM, John W. Linville wrote:
> > >>Despite the [RFC], I am applying this.  I should have reverted all
> > >>of this three weeks ago...
> > John can you please push this to stable kernel ?
> 
> Stable folks, this is the commit in Linus's tree;
> 
> commit 0f5cd45960173ba5b36727decbb4a241cbd35ef9

Too bad this commit doesn't apply to the .37-stable tree :(

Can someone provide stable@kernel.org a backported version of this?

thanks,

greg k-h
