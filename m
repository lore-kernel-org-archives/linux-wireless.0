Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37753 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbcDZIMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:12:52 -0400
Received: by mail-wm0-f44.google.com with SMTP id n3so22665776wmn.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 01:12:51 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] nl80211: use nla_put_u64_64bit() for the remaining u64
 attributes
References: <1461657251-12528-1-git-send-email-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Message-ID: <571F22F6.9070601@6wind.com> (sfid-20160426_101258_282541_1CB2F705)
Date: Tue, 26 Apr 2016 10:12:38 +0200
MIME-Version: 1.0
In-Reply-To: <1461657251-12528-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 26/04/2016 09:54, Johannes Berg a écrit :
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Nicolas converted most users, but didn't realize some were generated
> by macros. Convert those over as well.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
