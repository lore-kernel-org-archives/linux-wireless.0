Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab2HBOuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 10:50:07 -0400
Date: Thu, 2 Aug 2012 10:49:54 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 0/2] Fix lockdep warning in brcmsmac
Message-ID: <20120802144953.GJ1785@zod.bos.redhat.com> (sfid-20120802_165012_696268_FF42DD31)
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
 <20120802002353.GD1785@zod.bos.redhat.com>
 <20120802015320.GA25933@thinkpad-t410>
 <20120802120230.GE1785@zod.bos.redhat.com>
 <20120802125102.GF1785@zod.bos.redhat.com>
 <501A83AF.9060706@broadcom.com>
 <20120802134512.GG1785@zod.bos.redhat.com>
 <501A880A.6030000@broadcom.com>
 <20120802144529.GI1785@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120802144529.GI1785@zod.bos.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 02, 2012 at 10:45:29AM -0400, Josh Boyer wrote:
> I'll go test Seth's patches now.  I hate computers.

And with Seth's patches, I no longer see the cfg80211 warning
backtrace.  It's likely too late, but feel free to add:

Tested-by: Josh Boyer <jwboyer@redhat.com>


Thanks again everyone.

josh
