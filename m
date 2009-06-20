Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:58429 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZFTM7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 08:59:16 -0400
Message-ID: <4A3CDD2A.1060505@lwfinger.net>
Date: Sat, 20 Jun 2009 07:59:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Question about rfkill
References: <4A3C5D49.2000106@lwfinger.net> <1245497653.16399.27.camel@johannes.local>
In-Reply-To: <1245497653.16399.27.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

> No need, radio_enabled is intended to be removed, because if you rfkill
> now cfg80211 will force the interfaces down. Some time later way may
> need to add a way to disable just the radio again, but that will be
> different and for different purposes.

In b43/b43legacy, the driver can determine when the hw has required an
rfkill, but what is the "approved" method for determining if userspace
has killed it?

Larry

