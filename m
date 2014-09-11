Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55893 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaIKKHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:07:11 -0400
Message-ID: <1410430028.1825.8.camel@jlt4.sipsolutions.net> (sfid-20140911_120722_493338_0E074794)
Subject: Re: [PATCH] cfg80211: don't put kek/kck/replay counter on the stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Sep 2014 12:07:08 +0200
In-Reply-To: <1410377286-20914-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410377286-20914-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-10 at 22:28 +0300, Emmanuel Grumbach wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no need to put the values on the stack, just pass a
> pointer to the data in the nl80211 message. This reduces stack
> usage and avoids potential issues with putting sensitive data
> on the stack.

Applied.

johannes

