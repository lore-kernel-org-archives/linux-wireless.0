Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43195 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbYIZFpK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 01:45:10 -0400
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <43e72e890809252239g2a6207f9r581b970388d9df14@mail.gmail.com>
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 <1222245882.18015.62.camel@johannes.berg>
	 <1222328058.2510.470.camel@debian.sh.intel.com>
	 <1222334592.10563.59.camel@johannes.berg>
	 <1222401242.2510.519.camel@debian.sh.intel.com>
	 <43e72e890809252113h624a8d91jd859935ae5afed10@mail.gmail.com>
	 <1222406884.2510.534.camel@debian.sh.intel.com>
	 <43e72e890809252239g2a6207f9r581b970388d9df14@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 13:44:26 +0800
Message-Id: <1222407866.2510.542.camel@debian.sh.intel.com> (sfid-20080926_074521_147608_ECE8273B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-25 at 23:39 -0600, Luis R. Rodriguez wrote:
> 
> Yes, this detail of information was conveyed to me at OLS by Guy. This
> is why we decided to add support for letting the driver not pass an
> alpha2 but to just build the regulatory domain structure itself and
> pass it. I even provided an example of how to do this in the
> Documentation/networking/regulatory.txt and tested it myself.
> 
> Essentially this was added with your drivers in mind :)

Thanks. We will work on this.

-yi

