Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:10693 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbZJNQgx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 12:36:53 -0400
Subject: Re: iwl3945: page allocation failure. order:5, mode:0x8020
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20091014143347.GD2890@tuxdriver.com>
References: <878wfenmmf.fsf@purkki.valot.fi>
	 <20091014143347.GD2890@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 09:36:16 -0700
Message-Id: <1255538176.21134.23.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-10-14 at 07:33 -0700, John W. Linville wrote:
> On Wed, Oct 14, 2009 at 04:14:32PM +0300, Kalle Valo wrote:
> 
> > I didn't reboot during update, I only did 'modprobe -r iwl3945;
> > modprobe iwl3945', so there's a small chance that something went wrong
> > during update. But I still suspect something else is wrong because I
> > have never seen this error before. 
> 
> This sounds a lot like the ongoing iwlagn allocation thread...
> 

Could also be a duplicate of http://lkml.org/lkml/2009/9/15/163, which
is a order-5 allocation failure during reload of e100.

Even so, yes, that email thread John refers to considers this case as
well as the iwlagn ones that have been popping up. I added this report
to that thread and added Kalle to the cc list.

See http://thread.gmane.org/gmane.linux.drivers.ipw3945.devel/5313 and
also kernel bug 14141.

Reinette


