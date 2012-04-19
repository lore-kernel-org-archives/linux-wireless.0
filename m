Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12083 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab2DSNiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 09:38:20 -0400
Date: Thu, 19 Apr 2012 16:39:09 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
Message-ID: <20120419133907.GD16002@aemeltch-MOBL1> (sfid-20120419_153825_827365_2F5AC8CF)
References: <4F84A422.3030900@sipsolutions.net>
 <4F84A52A.7050905@sipsolutions.net>
 <20120411071119.GC17779@aemeltch-MOBL1>
 <1334714611.3725.34.camel@jlt3.sipsolutions.net>
 <20120418121551.GE19228@aemeltch-MOBL1>
 <4F8ED1D0.1070401@sipsolutions.net>
 <20120418145202.GH19228@aemeltch-MOBL1>
 <4F8ED913.4040807@sipsolutions.net>
 <20120419063558.GA16002@aemeltch-MOBL1>
 <4F9012E9.1040409@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F9012E9.1040409@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, Apr 19, 2012 at 06:28:09AM -0700, Johannes Berg wrote:
> On 4/18/2012 11:36 PM, Andrei Emeltchenko wrote:
> >>>>No, this is incorrect. If one device wants to connect on one
> >>>>channel, the other typically has to use the same channel. If one
> >>>>device wants to scan, the other will be affected. Some hardware may
> >>>>support switching around between two channels, but might also
> >>>>support more than 2 virtual interfaces, so again they won't be
> >>>>independent.
> >>>
> >>>BTW: which devices can switch channels?
> >>
> >>None today, I'm working on it.
> >
> >If this is not possible how people setup wireless hotspot using virtual
> >interfaces and run wpa_supplicant and hostapd on each separately.
> >Like here:
> >
> >http://linuxalfi.wordpress.com/2011/11/08/connectify-for-linux-with-single-wireless-interface/
> 
> Of course it's possible. Are you deliberately misunderstanding me?
> 
> You cannot use more than one channel today. We are changing that. To
> do good channel management, rather than hard-coding it in your
> config, you want to run a single wpa_s controlling all interfaces.

Can wpa_supplicant be an AP? I though that functionality is split to
hostap and wpa_supplicant.

Best regards 
Andrei Emeltchenko 
