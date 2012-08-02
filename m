Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3874 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab2HBNmT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 09:42:19 -0400
Message-ID: <501A83AF.9060706@broadcom.com> (sfid-20120802_154222_982346_3D682349)
Date: Thu, 2 Aug 2012 15:42:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Josh Boyer" <jwboyer@redhat.com>
cc: "Seth Forshee" <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 0/2] Fix lockdep warning in brcmsmac
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
 <20120802002353.GD1785@zod.bos.redhat.com>
 <20120802015320.GA25933@thinkpad-t410>
 <20120802120230.GE1785@zod.bos.redhat.com>
 <20120802125102.GF1785@zod.bos.redhat.com>
In-Reply-To: <20120802125102.GF1785@zod.bos.redhat.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2012 02:51 PM, Josh Boyer wrote:
> That didn't help.  I've tried multiple module load orderings without
> anything being shown on the bcma bus.  The modules all load, but no
> devices are created.  It's as if the hardware was removed or something.
> Puzzling.
> 
> josh

Can you share the kerne configuration?

Gr. AvS

