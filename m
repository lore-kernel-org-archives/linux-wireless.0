Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2DSOVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 10:21:30 -0400
Message-ID: <4F901F69.4000304@sipsolutions.net> (sfid-20120419_162135_829232_B5010B5B)
Date: Thu, 19 Apr 2012 07:21:29 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
References: <4F84A422.3030900@sipsolutions.net> <4F84A52A.7050905@sipsolutions.net> <20120411071119.GC17779@aemeltch-MOBL1> <1334714611.3725.34.camel@jlt3.sipsolutions.net> <20120418121551.GE19228@aemeltch-MOBL1> <4F8ED1D0.1070401@sipsolutions.net> <20120418145202.GH19228@aemeltch-MOBL1> <4F8ED913.4040807@sipsolutions.net> <20120419063558.GA16002@aemeltch-MOBL1> <4F9012E9.1040409@sipsolutions.net> <20120419133907.GD16002@aemeltch-MOBL1>
In-Reply-To: <20120419133907.GD16002@aemeltch-MOBL1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/19/2012 6:39 AM, Andrei Emeltchenko wrote:
>> You cannot use more than one channel today. We are changing that. To
>> do good channel management, rather than hard-coding it in your
>> config, you want to run a single wpa_s controlling all interfaces.
>
> Can wpa_supplicant be an AP? I though that functionality is split to
> hostap and wpa_supplicant.

Yes, it can.

johannes
