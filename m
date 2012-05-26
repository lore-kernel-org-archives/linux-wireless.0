Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43862 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2EZRRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 13:17:51 -0400
Date: Sat, 26 May 2012 12:17:49 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 3/8] brcm80211: smac: clean up channel.c
Message-ID: <20120526171749.GB11759@ubuntu-mba> (sfid-20120526_191754_126592_BA8054CA)
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-4-git-send-email-seth.forshee@canonical.com>
 <4FC008A1.9060005@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC008A1.9060005@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 26, 2012 at 12:33:05AM +0200, Arend van Spriel wrote:
> We are not supporting 40MHz right now, but it is on our roadmap. I would
> prefer to keep it, but git can recover it for me when that roadmap item
> is due.

The argument against keeping it is that it will be utterly broken by all
of the other changes. I could try to rework it along with the rest of
the code I guess, but I'd obviously be unable to test it.

I'll keep it in if you prefer, but I should probably add a comment
warning that the code needs some attention before it can be used.

