Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37945 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab1EJRKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 13:10:35 -0400
Message-ID: <4DC97189.1090105@openwrt.org> (sfid-20110510_191039_524493_F85DF1F7)
Date: Tue, 10 May 2011 19:10:33 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k and ath9k bugs still in 2.6.39-rc7
References: <4DC968FD.1040906@candelatech.com>
In-Reply-To: <4DC968FD.1040906@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-10 6:34 PM, Ben Greear wrote:
> As far as I can tell, ath5k is critically broken due to un-initilized
> spinlock (fixed in the patch I posted a few days ago), and ath9k stations
> won't work due to PS bugs that Felix posted fixes for yesterday.
Did you test my patch for that? I couldn't reproduce the issue, so I 
couldn't test whether my patch fully fixes it.

- Felix
