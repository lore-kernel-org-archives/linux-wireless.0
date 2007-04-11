Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:47648 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030459AbXDKWXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 18:23:06 -0400
Message-ID: <461D5FC5.5070404@linux.intel.com>
Date: Wed, 11 Apr 2007 15:23:01 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jkm@devicescape.com>,
	Simon Barber <simon@devicescape.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and  association
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com> <20070411194059.GA2436@tuxdriver.com> <461D3F48.70004@linux.intel.com> <200704111630.06160.flamingice@sourmilk.net>
In-Reply-To: <200704111630.06160.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Wednesday 11 April 2007 16:04, mabbas wrote:
>   
>> I am not familiar with userspace mlme what needed to be done?
>>     
> mac80211 has a userspace mlme mode which defers all things dealing with 
> management frames to userspace (wpa_supplicant). It basically disables all 
> the code in ieee80211_sta.c and routes management frames to a special 
> interface where wpa_supplicant (or hostap) handles things. This is preferred 
> and the ieee80211_sta.c code is there for backwards compatibility.
>
> No major features should be added to the in-kernel MLME (ieee80211_sta.c) but 
> even more importantly, your patch series does not provide the appropriate 
> hooks for a userspace MLME to support a driver using this 802.11n API.
>
> -Michael Wu
>   
where i can get mac80211 userspace mlme?
Mohamed
