Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58886 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705Ab3E3UCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 16:02:20 -0400
Message-ID: <51A7B049.9090201@openwrt.org> (sfid-20130530_220224_130638_1EA053DC)
Date: Thu, 30 May 2013 22:02:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Another try at getting pktgen to work with wifi.
References: <51A79E4A.7000609@candelatech.com>
In-Reply-To: <51A79E4A.7000609@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-05-30 8:45 PM, Ben Greear wrote:
> I'm trying to come up with a more acceptable patch to the problem discussed a few years
> ago:
> 
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/64582/focus=64626
> 
> The patch below appears to work as expected.  In pktgen, you just have to set
> the QoS to whatever value matches the queue you need.
> 
> This seem reasonable?
Why do you adjust the queue mapping instead of the skb priority? In that
other thread you mentioned that pktgen should be able to control the
queue, yet here you're taking queue control away from it for tx on mac80211.

- Felix

