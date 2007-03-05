Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:47790 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933457AbXCENqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 08:46:44 -0500
Message-ID: <45EC1F41.9070406@warmcat.com>
Date: Mon, 05 Mar 2007 13:46:41 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Filtering in Monitor Mode (was Question about PRISM2 header rate  field)
References: <45EA9E39.6080706@warmcat.com>	 <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com>	 <200703042210.52534.flamingice@sourmilk.net>	 <1173094447.6131.56.camel@johannes.berg>  <45EC1454.4080605@warmcat.com>	 <1173099910.6131.71.camel@johannes.berg>  <45EC18A9.50003@warmcat.com> <1173100957.6131.76.camel@johannes.berg>
In-Reply-To: <1173100957.6131.76.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> The power save mode argument still holds though, we might address that
> with non-promisc monitor interfaces even though they do have a couple of
> problems (you need to be associated on a different virtual netdev for it
> to make sense...)

Hi Johannes -

Yes non-hardware promisc is an interesting combination for the userspace 
MLME plan, since you have everything you need already without needing 
hardware promisc.  I guess the best way is to define a new MODE_ enum 
for MONITOR_LOCAL or something.

-Andy
