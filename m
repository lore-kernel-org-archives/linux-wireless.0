Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaC1I3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 04:29:03 -0400
Message-ID: <1395995337.4175.0.camel@jlt4.sipsolutions.net> (sfid-20140328_092908_138760_AA86EFC5)
Subject: Re: [PATCH] mac80211: add vif to flush call
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Fri, 28 Mar 2014 09:28:57 +0100
In-Reply-To: <1395912629-1458-1-git-send-email-egrumbach@gmail.com> (sfid-20140327_103039_397719_35FA165E)
References: <1395912629-1458-1-git-send-email-egrumbach@gmail.com>
	 (sfid-20140327_103039_397719_35FA165E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-03-27 at 11:30 +0200, Emmanuel Grumbach wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> This will allow the low level driver to make decision based
> on the vif such as queues etc...
> Since the vif might be NULL, we can't add it to the tracing
> functions.

Applied.

johannes

