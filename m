Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41703 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbcEaNcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 09:32:31 -0400
Message-ID: <1464701546.3076.30.camel@sipsolutions.net> (sfid-20160531_153234_765730_3FB18799)
Subject: Re: [PATCH v2] cfg80211: Advertise extended capabilities per
 interface type to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	amarnath@qca.qualcomm.com, usdutt@qti.qualcomm.com
Date: Tue, 31 May 2016 15:32:26 +0200
In-Reply-To: <1463375464-9025-1-git-send-email-vkanchan@qti.qualcomm.com>
References: <1463375464-9025-1-git-send-email-vkanchan@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-05-16 at 10:41 +0530, Kanchanapally, Vidyullatha wrote:
> From: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
> 
> The driver extended capabilities may differ for different
> interface types which the userspace needs to know (for
> example the fine timing measurement initiator and responder
> bits might differ for a station and AP). Add a new nl80211
> attribute to provide extended capabilities per interface type
> to userspace.
> 
Applied.

johannes
