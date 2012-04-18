Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29847 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab2DRMPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 08:15:05 -0400
Date: Wed, 18 Apr 2012 15:15:52 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
Message-ID: <20120418121551.GE19228@aemeltch-MOBL1> (sfid-20120418_141510_660841_28412662)
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <4F846257.1060807@sipsolutions.net>
 <1334092668.16897.54.camel@aeonflux>
 <4F84A422.3030900@sipsolutions.net>
 <4F84A52A.7050905@sipsolutions.net>
 <20120411071119.GC17779@aemeltch-MOBL1>
 <1334714611.3725.34.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334714611.3725.34.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, Apr 17, 2012 at 07:03:31PM -0700, Johannes Berg wrote:
> > I am new to the wireless code but can new virtual interface separate those
> > interfaces? They can have different MAC addresses and you can run
> > wpa_supplicant for each virtual interface separately.
> 
> It's never in your best interest to run one supplicant per virtual
> interface, you want to run one per piece of hardware so it can
> coordinate between virtual interfaces.

Do I understand it right that virtual interfaces are like separate devices from
user point of view? If I create virtual interface and assign MAC I can
transfer data through it without affecting other interfaces? Then
wpa_supplicant does not need to know about it at all.

Best regards 
Andrei Emeltchenko 
