Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56940 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab3CELtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 06:49:11 -0500
Message-ID: <5135DBB4.5090407@openwrt.org> (sfid-20130305_124917_595825_7BE32BBE)
Date: Tue, 05 Mar 2013 12:49:08 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211/minstrel_ht: increase sampling frequency
 of some slower rates
References: <1362311392-83648-1-git-send-email-nbd@openwrt.org> <alpine.DEB.2.02.1303051432550.23906@icf.org.ru>
In-Reply-To: <alpine.DEB.2.02.1303051432550.23906@icf.org.ru>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-05 11:35 AM, Georgiewskiy Yuriy wrote:
> On 2013-03-03 12:49 +0100, Felix Fietkau wrote linux-wireless@vger.kernel.org:
> 
> Hi, in my case this two patches cause throughput drop, withous it i have 50-55Mbs
> with it applied only 35-40.
Please show me the rate control statistics from debugfs.

- Felix

