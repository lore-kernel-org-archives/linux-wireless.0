Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-1920.google.com ([74.125.78.145]:19614 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZGIXNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 19:13:10 -0400
Received: by ey-out-1920.google.com with SMTP id 3so115249eyh.36
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 16:13:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247174482.17896.1304.camel@rc-desk>
References: <1247174482.17896.1304.camel@rc-desk>
Date: Fri, 10 Jul 2009 01:13:08 +0200
Message-ID: <b170af450907091613l1607f664he482e13e6fe268bd@mail.gmail.com>
Subject: Re: [ipw3945-devel] iwlwifi 4965 uCode available
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/9 reinette chatre <reinette.chatre@intel.com>:
> Version 228.61.2.24 of uCode for Intel Wireless WiFi Link 4965AGN is now
> available for download from
> http://intellinuxwireless.org/?n=Downloads
>
> Changes:
>
> -- More graceful handling of Rx hangs (NMI)
> -- More reliable scanning
> -- Wait 10 seconds after association before power down
> -- Reset receiver via retune after missing beacons
> -- Disable TGK measurement when receiving packet
> -- More reliable Tx of ACK/BA/CTS

Nice work, AFAICU this should fix a few annoying issues, right?

Can you reveal some plans of upgrading 5100/5300/5350 uCode? Any
estimate would be nice to known. This month? This year?

-- 
Rafał Miłecki
