Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:40028 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbXFWF7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 01:59:11 -0400
Message-ID: <467CB691.2090806@warmcat.com>
Date: Sat, 23 Jun 2007 06:58:41 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
References: <1182418939.10821.8.camel@johannes.berg>	 <20070621143558.68fc8e4a@griffin.suse.cz>	 <1182429920.21939.1.camel@johannes.berg>	 <20070621151441.500d62d5@griffin.suse.cz>	 <20070622154545.29eeebdb@griffin.suse.cz> <467BDCB1.1010604@warmcat.com>	 <1182526221.21939.94.camel@johannes.berg>	 <20070622174953.500817e0@griffin.suse.cz> <1182543620.21939.98.camel@johannes.berg>
In-Reply-To: <1182543620.21939.98.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

>> I think netlink is fine if it is used for injection too (at least of
>> management frames and WPA stuff).
> 
> I don't disagree. I'd even say that having both injection interfaces is
> fine since they really cover different use cases.

What are these different usage cases such that you need to maintain the
two different ways of doing it?

-Andy
