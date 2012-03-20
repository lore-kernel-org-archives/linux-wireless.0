Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2CTNHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 09:07:37 -0400
Subject: Re: Dell E6400 + Windows XP can not work on intel N-6205 AP mode
 for compat-wireless-2012-03-18.tar.bz2 package
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhong Hongbo <hongbo.zhong@windriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Cao, Qingtao (Harry)" <Qingtao.Cao@windriver.com>,
	"Gao, Guijin" <Guijin.Gao@windriver.com>,
	"'Cabuk, Yusuf'" <Yusuf.Cabuk@windriver.com>
In-Reply-To: <4F687F4E.4030203@windriver.com>
References: <4F687667.1030605@windriver.com>
	 <1332247526.3329.17.camel@jlt3.sipsolutions.net>
	 <4F687D82.2010201@windriver.com>  <4F687F4E.4030203@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 14:07:35 +0100
Message-ID: <1332248855.3329.18.camel@jlt3.sipsolutions.net> (sfid-20120320_140741_239337_56BB4E14)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-20 at 20:59 +0800, Zhong Hongbo wrote:
> On 03/20/2012 08:52 PM, Zhong Hongbo wrote:
> > On 03/20/2012 08:45 PM, Johannes Berg wrote:
> >
> >> On Tue, 2012-03-20 at 20:21 +0800, Zhong Hongbo wrote:
> >>> I try the latest compat-wireless package to test Intel Centrino N-6205
> >>> Taylor Peak Wi-Fi card  AP mode.
> >>>
> >>> 1. Test enviroment
> >>> My Wi-Fi client:
> >>> Dell Latitude E6400 desktop + Ubuntu 10.04,
> >>> Dell Latitude E6400 desktop + Windows XP.
> >>>
> >>> Compat-wireless package: compat-wireless-2012-03-18.tar.bz2
> >>>
> >>> Wi-Fi AP: Intel Centrino N-6205 Taylor Peak
> >>>
> >>> 2. issue describe
> >>> When I use E6400 + Ubuntu 10.04 connect to intel N-6205 Taylor PeaK
> >>> AP， I can go to internet to browse web. E6400 + Windows XP can
> >>> connect to intel N-6205 AP, But I can not go to internet.
> >>> Is it interactions issue for the compat-wirelss package? Welcome any
> >>> suggestion.
> >> That's a bit confusing. Are you running DHCP etc. correctly?
> > Thanks response. Yes, Because E6400 + ubuntu 10.04 can go to internet.
> > I use E6400 + Ubuntu and E6400 + Windows to connect the Wi-Fi AP at the same time.
> And E6400 + Windows get the correct ip and dns.

Ok. Maybe Windows is using (more agressive) powersaving? Can you enable
PS debugging in ma80211?

johannes

