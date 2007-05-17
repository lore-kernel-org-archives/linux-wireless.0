Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35078 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbXEQC4c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2007 22:56:32 -0400
Message-ID: <464BC459.4030105@garzik.org>
Date: Wed, 16 May 2007 22:56:25 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net>
In-Reply-To: <200705162151.32910.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Wednesday 16 May 2007 17:45, James Ketrenos wrote:
>> This patch adds the iwlwifi project directory and sources needed to
>> build the mac80211 based wireless drivers for the Intel PRO/Wireless
>> 3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN adapters.
>>
> Looks much better than when I last checked. A few comments:
> 
> - The enter/leave stuff should be removed.

This is the maintainer's personal preference.  I put them in all my 
drivers, and they look perfectly fine here.

	Jeff



