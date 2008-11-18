Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55350 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751201AbYKRQiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 11:38:10 -0500
Message-ID: <4922EF68.9020504@gmx.de> (sfid-20081118_173815_597792_066E90FD)
Date: Tue, 18 Nov 2008 17:38:00 +0100
From: Thomas Witt <witt_th@gmx.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	=?ISO-8859-1?Q?Jan_Vc=28el=E1k?= <vcelak.jan@seznam.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
References: <1226969241.4014.24.camel@johannes.berg>	 (sfid-20081118_014839_339263_738F563C) <1227005769.4014.50.camel@johannes.berg>
In-Reply-To: <1227005769.4014.50.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> I'd like to ask anyone who is CC'ed (those are people I know ran into
>> the bug) to try this patch.
> 
> And here's a version against v2.6.28-rc5 (build tested only)



That one fixes the Problem for me,

Thomas.
