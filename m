Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:21231 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030654AbXDLSMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 14:12:01 -0400
Message-ID: <461E766F.7010701@linux.intel.com>
Date: Thu, 12 Apr 2007 11:11:59 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jkm@devicescape.com>,
	Simon Barber <simon@devicescape.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and  association
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com> <200704111630.06160.flamingice@sourmilk.net> <461D5FC5.5070404@linux.intel.com> <200704111856.55885.flamingice@sourmilk.net>
In-Reply-To: <200704111856.55885.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Wednesday 11 April 2007 18:23, mabbas wrote:
>   
>> where i can get mac80211 userspace mlme?
>> Mohamed
>>     
> It's wpa_supplicant with mlme code turned on.
>
> Git repo: git://w1.fi/srv/git/hostap.git
>
> -Michael
just adding the hooks to userspace mlme would be enough to get these 
patches accepted. then I can look into wpa_supplicant.
Mohamed
> 	
>   
