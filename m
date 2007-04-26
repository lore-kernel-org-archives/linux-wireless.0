Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:35487 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbXDZFPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 01:15:18 -0400
Message-ID: <46303565.9040709@lwfinger.net>
Date: Thu, 26 Apr 2007 00:15:17 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Wireless rates with mac80211
References: <462F9617.8010207@lwfinger.net> <200704251637.53683.flamingice@sourmilk.net> <463027A3.9040201@lwfinger.net> <200704260022.48747.flamingice@sourmilk.net>
In-Reply-To: <200704260022.48747.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Thursday 26 April 2007 00:16, Larry Finger wrote:
>
> Patches welcome. The rate control API currently has no easy way to obtain the 
> current rate which is part of why SIOCGIWRATE hasn't been implemented yet.

What is in txrate in struct sta_info? Isn't it the rate to be used for the next transmission?

Larry
