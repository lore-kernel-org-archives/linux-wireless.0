Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32867 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbZGMUic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 16:38:32 -0400
Subject: Re: [ipw3945-devel] iwlwifi 4965 uCode available
From: reinette chatre <reinette.chatre@intel.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <b170af450907131332x65b43bbfxa76ff2abc743317a@mail.gmail.com>
References: <1247174482.17896.1304.camel@rc-desk>
	 <b170af450907091613l1607f664he482e13e6fe268bd@mail.gmail.com>
	 <1247182010.17896.1344.camel@rc-desk>
	 <b170af450907131330o7eda50bakd6119f47af35d564@mail.gmail.com>
	 <b170af450907131332x65b43bbfxa76ff2abc743317a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jul 2009 13:38:31 -0700
Message-Id: <1247517511.17896.1652.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-13 at 13:32 -0700, Rafał Miłecki wrote:
> W dniu 13 lipca 2009 22:30 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> > W dniu 10 lipca 2009 01:26 użytkownik reinette chatre
> > <reinette.chatre@intel.com> napisał:
> >>> Can you reveal some plans of upgrading 5100/5300/5350 uCode? Any
> >>> estimate would be nice to known. This month? This year?
> >>
> >> I am not aware of any scheduled date for a new release. Are there
> >> critical issues that you are aware of that requires a new uCode?
> >
> > I noticed new bug report about firmware failure on scp (using new
> > firmware). I use ssh/sftp/scp a lot, so it doesn't sound nice to me.
> >
> > Moreover it seems to be quite reproductable, so I'm scared of hittint
> > it quite often.
> 
> Probably I really should post link to bug report:
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2004

This bug was reported against 5100 series hardware and is not present in
4965. Even so, this bug was fixed in the driver and the patch has
already been pushed upstream.

Reinette


