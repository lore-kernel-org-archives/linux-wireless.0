Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:42230 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbbKZQws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 11:52:48 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>,
	"Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kaufman\, Liad" <liad.kaufman@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: add hwmon device for the temperature sensor
References: <541F23D2.90600@gmail.com>
	<1411327338-23099-13-git-send-email-egrumbach@gmail.com>
	<87ppeoc4s0.fsf@nemi.mork.no>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5261F1@hasmsx107.ger.corp.intel.com>
	<87d2amd24t.fsf@nemi.mork.no>
	<0BA3FCBA62E2DC44AF3030971E174FB31B526977@hasmsx107.ger.corp.intel.com>
	<1411760678.18773.5.camel@dubbel>
	<A66968BA-6B95-4437-8A95-5EBFD6BCF583@mork.no>
	<877flbuke9.fsf_-_@nemi.mork.no>
	<1448552793.2167.17.camel@sipsolutions.net>
Date: Thu, 26 Nov 2015 17:52:38 +0100
In-Reply-To: <1448552793.2167.17.camel@sipsolutions.net> (Johannes Berg's
	message of "Thu, 26 Nov 2015 16:46:33 +0100")
Message-ID: <874mg8vh2h.fsf@nemi.mork.no> (sfid-20151126_175251_329450_BC2194D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi Bjørn,
>
>> I got bored and made an attempt on this. Still just for fun.  I don't
>> have a real usecase.  What do you think?  Completely useless?
>
> It's not so bad :)
>
> However, it's (soon going to be) redundant, we're planning to implement
> a thermal_zone_device in this code, and if you then set the Kconfig
> option THERMAL_HWMON you'll get a hwmon to go along with it. So I'd
> rather not take this patch since we'd otherwise end up with two ways to
> do the same thing in the driver.

Ah, right.  I wondered a bit about that, but concluded that you probably
didn't want it since you had all your own temp limit handling.

Sounds like a good plan to me


Bjørn
