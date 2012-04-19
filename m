Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2DSOVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 10:21:11 -0400
Message-ID: <4F901F51.3000704@sipsolutions.net> (sfid-20120419_162113_929488_23086435)
Date: Thu, 19 Apr 2012 07:21:05 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: add option to disable 5GHz band
References: <1334830280-3019-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1334830280-3019-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/19/2012 3:11 AM, Stanislaw Gruszka wrote:
> There are various problems happened on 5GHz band not observed on
> 2.4 GHz (microcode errors, queue stuck, etc... ) . Also roaming
> between 5GHz AP and 2GHz does not work very well. To workaround
> the problems add option to disable 5GHz support. This will help
> on environments where APs are dual-band, and devices will not try
> to associate on band where issues happen.

Would it make sense to somehow do this in cfg80211? Today, our driver 
may be the only one having this problem (which I've never really heard 
about?), but is it always going to be?

johannes
