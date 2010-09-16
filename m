Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60385 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0IPUF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 16:05:59 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: 2.6.36-rc4/iwl: warning triggered in net/mac80211/scan.c:266
Date: Thu, 16 Sep 2010 22:05:53 +0200
Cc: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
References: <20100914142814.GA8744@redhat.com>
In-Reply-To: <20100914142814.GA8744@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201009162205.54034.maciej.rutecki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On wtorek, 14 września 2010 o 16:28:15 Michael S. Tsirkin wrote:
> I am running 2.6.36-rc4 on T60 with an iwlagn wireless card:
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN
> [Shiloh] Network Connection
> 
> I was compiling a large file which stressed the box heavily, and the
> following warning in net/mac80211/scan.c triggered:

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=18692
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
