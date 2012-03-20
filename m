Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2CTMp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 08:45:29 -0400
Subject: Re: Dell E6400 + Windows XP can not work on intel N-6205 AP mode
 for compat-wireless-2012-03-18.tar.bz2 package
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhong Hongbo <hongbo.zhong@windriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Cao, Qingtao (Harry)" <Qingtao.Cao@windriver.com>,
	"Gao, Guijin" <Guijin.Gao@windriver.com>,
	"'Cabuk, Yusuf'" <Yusuf.Cabuk@windriver.com>
In-Reply-To: <4F687667.1030605@windriver.com>
References: <4F687667.1030605@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 13:45:26 +0100
Message-ID: <1332247526.3329.17.camel@jlt3.sipsolutions.net> (sfid-20120320_134533_086058_EB0A585F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-20 at 20:21 +0800, Zhong Hongbo wrote:
> I try the latest compat-wireless package to test Intel Centrino N-6205
> Taylor Peak Wi-Fi card  AP mode.
> 
> 1. Test enviroment
> My Wi-Fi client:
> Dell Latitude E6400 desktop + Ubuntu 10.04,
> Dell Latitude E6400 desktop + Windows XP.
> 
> Compat-wireless package: compat-wireless-2012-03-18.tar.bz2
> 
> Wi-Fi AP: Intel Centrino N-6205 Taylor Peak
> 
> 2. issue describe
> When I use E6400 + Ubuntu 10.04 connect to intel N-6205 Taylor PeaK
> AP， I can go to internet to browse web. E6400 + Windows XP can
> connect to intel N-6205 AP, But I can not go to internet.
> Is it interactions issue for the compat-wirelss package? Welcome any
> suggestion.

That's a bit confusing. Are you running DHCP etc. correctly?

johannes

