Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40404 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbZG2V5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:57:11 -0400
Subject: Re: [Linux Wireless] Update of "en/users/Download" by
 ReinetteChatre
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com>
References: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net>
	 <43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 14:57:11 -0700
Message-Id: <1248904631.1216.1027.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-29 at 14:53 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 29, 2009 at 2:45 PM, Linux
> Wireless<johannes@sipsolutions.net> wrote:
> > Dear Wiki user,
> >
> > You have subscribed to a wiki page or wiki category on "Linux Wireless" for change notification.
> >
> > The "en/users/Download" page has been changed by ReinetteChatre:
> > http://wireless.kernel.org/en/users/Download?action=diff&rev1=93&rev2=94
> >
> >  }}}
> >  '''Install''':
> >
> > - We use the updates/ directory so your distribution's drivers are left intact.
> > + We use the updates/ directory so your distribution's drivers are left intact. By default depmod will search this directory first, but if you find that it does not then check that your depmod.conf file lists the search order correctly with ''updates'' appearing first (before ''built-in'').
> 
> Hm, so compat-wireless now actually checks this for you and if its not
> there it adds it for you. Was there an issue with a particular user on
> this?

Yes, a madriva user ran into this problem. See
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2061#c6 


Reinette


