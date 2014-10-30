Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:43590 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758164AbaJ3JOY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 05:14:24 -0400
Message-ID: <5452016E.70303@linux.intel.com> (sfid-20141030_101428_291533_C25172DB)
Date: Thu, 30 Oct 2014 11:14:22 +0200
From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: nl80211: Broadcast CMD_NEW_INTERFACE and CMD_DEL_INTERFACE
References: <1414413807-7649-1-git-send-email-tomasz.bursztyka@linux.intel.com>	 (sfid-20141027_134340_833740_6984A324) <1414597472.1827.12.camel@jlt4.sipsolutions.net>
In-Reply-To: <1414597472.1827.12.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> It really bloats the*arguments*  more than anything, no way to change
> that, say by sending the delete message before the wdev is destroyed?

You mean building the nlmsg before? (sending it would be wrong if the 
deletion
fails afterwards)

I'll redo a patch, that sounds better yes.

Tomasz


