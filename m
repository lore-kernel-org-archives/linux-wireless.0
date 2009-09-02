Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46746 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZIBQ5R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 12:57:17 -0400
Subject: Re: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Lutomirski <luto@mit.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1251910084.24846.29.camel@johannes.local>
References: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
	 <1251906970.13180.137.camel@rc-desk>
	 <1251910084.24846.29.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 09:57:20 -0700
Message-Id: <1251910640.13180.161.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-09-02 at 09:48 -0700, Johannes Berg wrote:
> On Wed, 2009-09-02 at 08:56 -0700, reinette chatre wrote:
> 
> > 2.6.32 will have power save support disabled also.
> 
> Only by default -- there you can actually enable it as a user with
> "iwconfig wlan0 power timeout 100ms" to turn it on -- unless that patch
> didn't go in?

yes - sorry, I should have added that it is disabled by default but
users can enable it using iwconfig.

Reinette


