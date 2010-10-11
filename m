Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58288 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab0JKOZn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 10:25:43 -0400
Message-ID: <4CB31F02.4080300@ti.com>
Date: Mon, 11 Oct 2010 16:28:18 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 03/03] wl1271: 11n Support, functionality and configuration
 ability
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>	 <1286388491-28752-5-git-send-email-shahar_levi@ti.com>	 <1286528736.21349.42.camel@chilepepper>  <4CB1DAC8.6050609@ti.com> <1286805356.24158.3.camel@chilepepper>
In-Reply-To: <1286805356.24158.3.camel@chilepepper>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho wrote:
> True, but if you don't have the ifdef you're adding unnecessary code in
> the RX data path.
> 
> 

> Same here, this loop will add more CPU cycles in the TX data path
> unnecessarily.
> 
you right, will be fix on v3.
Thanks,
Shahar
