Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2LDO4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:56:54 -0500
Message-ID: <1354633038.9608.3.camel@jlt4.sipsolutions.net> (sfid-20121204_155658_509490_E48BCD66)
Subject: Re: [PATCH v2] mac80211: add debug file for mic failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 04 Dec 2012 15:57:18 +0100
In-Reply-To: <50BE0606.3000103@posedge.com>
References: <50BE0606.3000103@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-04 at 19:47 +0530, Saravana wrote:
> The mic failure count will provide the number of mic failure that 
> have happened without a countermeasure being started. Once the 
> countermeasure is started, the counter will be reset to 0.
> This count will be helpful when the consecutive 
> mic failure occur at intervals greater than 60 seconds regularly(frequently).

Applied.

johannes

