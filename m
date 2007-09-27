Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:38788 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXI0O1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 10:27:33 -0400
Message-ID: <46FBBD78.2050001@oracle.com>
Date: Thu, 27 Sep 2007 07:26:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH] iwlwifi: set fixed rate through debugfs
References: <11908636643693-git-send-email-yi.zhu@intel.com>	 <11908636662994-git-send-email-yi.zhu@intel.com>	 <11908636683204-git-send-email-yi.zhu@intel.com>	 <11908636692415-git-send-email-yi.zhu@intel.com>	 <119086367088-git-send-email-yi.zhu@intel.com>	 <11908636712746-git-send-email-yi.zhu@intel.com>	 <11908636732679-git-send-email-yi.zhu@intel.com>	 <11908636743625-git-send-email-yi.zhu@intel.com>	 <11908636753775-git-send-email-yi.zhu@intel.com>	 <11908636772860-git-send-email-yi.zhu@intel.com>	 <11908636781043-git-send-email-yi.zhu@intel.com>	 <1190863679136-git-send-email-yi.zhu@intel.com>	 <11908636801368-git-send-email-yi.zhu@intel.com>	 <11908636823439-git-send-email-yi.zhu@intel.com>	 <20070926213517.042008a9.randy.dunlap@oracle.com> <1190868222.25840.89.camel@debian.sh.intel.com>
In-Reply-To: <1190868222.25840.89.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi wrote:
> On Wed, 2007-09-26 at 21:35 -0700, Randy Dunlap wrote:
>> Is this just for developer/tester debug use, not for normal use? 
> 
> Yeah, this is for developer debug only at this time.

Yes, as long as it's using debugfs, it's forever for developer/tester use.
You can't expect or require debugfs to be built or mounted for normal use.

-- 
~Randy
Phaedrus says that Quality is about caring.
