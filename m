Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38133 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbbKZRFA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 12:05:00 -0500
Message-ID: <1448557497.2167.24.camel@sipsolutions.net> (sfid-20151126_180504_547174_BF69C011)
Subject: Re: [PATCH] iwlwifi: mvm: add hwmon device for the temperature
 sensor
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Luca Coelho <luca@coelho.fi>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kaufman, Liad" <liad.kaufman@intel.com>
Date: Thu, 26 Nov 2015 18:04:57 +0100
In-Reply-To: <874mg8vh2h.fsf@nemi.mork.no>
References: <541F23D2.90600@gmail.com>
	 <1411327338-23099-13-git-send-email-egrumbach@gmail.com>
	 <87ppeoc4s0.fsf@nemi.mork.no>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B5261F1@hasmsx107.ger.corp.intel.com>
	 <87d2amd24t.fsf@nemi.mork.no>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B526977@hasmsx107.ger.corp.intel.com>
	 <1411760678.18773.5.camel@dubbel>
	 <A66968BA-6B95-4437-8A95-5EBFD6BCF583@mork.no>
	 <877flbuke9.fsf_-_@nemi.mork.no>
	 <1448552793.2167.17.camel@sipsolutions.net> <874mg8vh2h.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Ah, right.  I wondered a bit about that, but concluded that you
> probably
> didn't want it since you had all your own temp limit handling.
> 

:)

We do, but we're going to have to be able to handle requests from the
platform to ask the device to do its part to reduce heating.

johannes
