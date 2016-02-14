Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39236 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbcBNTYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2016 14:24:41 -0500
Message-ID: <1455477875.2564.0.camel@sipsolutions.net> (sfid-20160214_202443_927931_A2EE8BF5)
Subject: Re: [PATCH 2/3] iwlwifi: mvm: move TX PN assignment for TKIP to the
 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Sun, 14 Feb 2016 20:24:35 +0100
In-Reply-To: <CANUX_P3Ybzowsf3Kg7TFhtpq+H4bDWMswrGHhkrvHKtnZaEVhA@mail.gmail.com> (sfid-20160214_183403_853776_9F1FCA58)
References: <1455450997-15409-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1455450997-15409-2-git-send-email-emmanuel.grumbach@intel.com>
	 <CANUX_P3Ybzowsf3Kg7TFhtpq+H4bDWMswrGHhkrvHKtnZaEVhA@mail.gmail.com>
	 (sfid-20160214_183403_853776_9F1FCA58)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-02-14 at 19:34 +0200, Emmanuel Grumbach wrote:
> 
> Since the 3rd patch needs to be dropped anyway, let's route this one
> through my tree as usual.

It doesn't really have to be dropped, why? We can just make the same
adjustment as for dvm in the patch.

johannes
