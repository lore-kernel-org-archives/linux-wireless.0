Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2LDTHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 14:07:32 -0500
Message-ID: <1354648076.9608.16.camel@jlt4.sipsolutions.net> (sfid-20121204_200736_394665_F50A4BB0)
Subject: Re: [PATCH v2] mac80211: add debug file for mic failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 04 Dec 2012 20:07:56 +0100
In-Reply-To: <1354633038.9608.3.camel@jlt4.sipsolutions.net> (sfid-20121204_155658_509490_E48BCD66)
References: <50BE0606.3000103@posedge.com>
	 <1354633038.9608.3.camel@jlt4.sipsolutions.net>
	 (sfid-20121204_155658_509490_E48BCD66)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-04 at 15:57 +0100, Johannes Berg wrote:
> On Tue, 2012-12-04 at 19:47 +0530, Saravana wrote:
> > The mic failure count will provide the number of mic failure that 
> > have happened without a countermeasure being started. Once the 
> > countermeasure is started, the counter will be reset to 0.
> > This count will be helpful when the consecutive 
> > mic failure occur at intervals greater than 60 seconds regularly(frequently).
> 
> Applied.

Never mind, dropped. It has a null pointer issue and still has
whitespace issues. Please figure out how to actually indent
parameters ...

Also, signed-off-by should be your full name, is that really just
"Saravana"? Your email seems to indicate there's something else
("saravanad")

johannes

