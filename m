Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35786 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbJOSGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 14:06:16 -0400
Received: by igbkq10 with SMTP id kq10so655227igb.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2015 11:06:15 -0700 (PDT)
Date: Thu, 15 Oct 2015 13:06:11 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] wireless-regdb: fix gHz to GHz
Message-ID: <20151015180611.GB31612@ubuntu-hedt> (sfid-20151015_200618_977019_D9147C78)
References: <1444918759-21559-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444918759-21559-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 15, 2015 at 04:19:19PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no "g" prefix, only "G" (1e9) that was clearly intended here.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied, thanks.
