Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22144 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbYLBU01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:26:27 -0500
Subject: Re: Issue with ifconfig down and 4965 driver
From: reinette chatre <reinette.chatre@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <491BF73B.4080403@linux.intel.com>
References: <BCB72601-9DA2-4D89-BDF1-7B96254DA17C@linux.intel.com>
	 <1226555293.1115.939.camel@rc-desk>  <491BF73B.4080403@linux.intel.com>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 12:27:23 -0800
Message-Id: <1228249643.10900.59.camel@rc-desk> (sfid-20081202_212631_374826_E88FE343)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-11-13 at 01:45 -0800, Marcel Holtmann wrote:
> Hi Reinette,
> 
> >> so I am running a 2.6.28-rc4 kernel and every time I stop
> >> wpa_supplicant or call ifconfig down on the 4965 card, I get a user
> >> noticeable delay (mouse freezes). Seems that some part inside the
> >> driver is actively sleeping with a busy-loop. This is really not an
> >> acceptable behavior since it is a day-to-day task to bring the device
> >> down. And for power concerns, we really wanna allow to bring down the
> >> interface.
> >>
> >
> > Please add your information to
> > http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1790
> 
> all information are already in the Bugzilla. It is nothing fancy and
> easy to reproduce. Do we have a patch for it?
> 

http://marc.info/?l=linux-wireless&m=122824886623698&w=2


Reinette

