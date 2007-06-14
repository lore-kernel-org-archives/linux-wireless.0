Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:33390 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692AbXFNH5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 03:57:07 -0400
Message-ID: <4670F4CE.1020106@warmcat.com>
Date: Thu, 14 Jun 2007 08:57:02 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH Try#12 0/3] Radiotap injection for Monitor Mode
References: <20070613093732.535166329@warmcat.com> <200706140018.41188.flamingice@sourmilk.net>
In-Reply-To: <200706140018.41188.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Wednesday 13 June 2007 02:37, andy@warmcat.com wrote:
>> These patches add the ability to inject packets down a monitor mode
>> interface for transmission according to a prepended radiotap header.
>>
> I've attached a patch to address remaining issues found by git, sparse, and 
> checkpatch.pl. With that, ACK.

Thanks for all the work you and Johannes put in with review and bug finding.

-Andy
