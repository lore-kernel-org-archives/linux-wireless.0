Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:12107 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbYFMO7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 10:59:51 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2564971rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 07:59:50 -0700 (PDT)
Message-ID: <48528B63.5030403@gmail.com> (sfid-20080613_165953_323086_83C841B0)
Date: Fri, 13 Jun 2008 16:59:47 +0200
From: =?ISO-8859-1?Q?Tor_H=E5kon_Haugen?= <tor.hakon.haugen@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with	disable_hw_scan=1
References: <484FEA26.1040305@gmail.com>	<1213241315.7814.696.camel@debian.sh.intel.com>	<20080612135936.GA5031@tuxdriver.com>	<1213342523.7814.865.camel@debian.sh.intel.com> <20080613130310.GA5333@tuxdriver.com>
In-Reply-To: <20080613130310.GA5333@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



John W. Linville wrote:
> On Fri, Jun 13, 2008 at 03:35:23PM +0800, Zhu Yi wrote:
>> On Thu, 2008-06-12 at 09:59 -0400, John W. Linville wrote:
>>> Honestly I'm tempted to change it to "enable_hw_scan" instead...
>> Give the advantages, I'd like to use it if we can fix the bug (I haven't
>> seen what the bug is myself). But you are free to change the default
>> value until it is fixed. There is no such problem for 4965, right?
> 
> AFAICT only the 3945 seems to need it.
> 

I can confirm that this also applies to 4965 as a friend of mine has 
this card. According to him the card works a lot better with the 
parameters "swcrypto=1" and "disable_hw_scan=1".


  Tor H. Haugen
