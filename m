Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3512 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab2EYWby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 18:31:54 -0400
Message-ID: <4FC00848.9060901@broadcom.com> (sfid-20120526_003158_177151_1ADD4195)
Date: Sat, 26 May 2012 00:31:36 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 0/8] brcm80211: smac: rework regulatory support
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 10:17 PM, Seth Forshee wrote:
> Hi Arnd,

You missed an 'e' ;-)

> Here's the latest update to the brcmsmac regulatory rework that I've
> been working on. I've broken it up into a series of smaller patches,
> cleaned things up, and finished what changes I can with the information
> available to me.

It took a while. There were some discussions and we agreed that your
changes establish a better integration with the regulatory framework.
There are some concerns about the content of the crda database, but that
is another thing outside the scope of your patches.

> I've attempted to maintain the same high-level behavior that the
> brcmsmac internal regulatory support currently enforces.

Appreciated. We can add/change in subsequent patches. I collected review
comments internally including mine. I will provide them in response to
each individual patch.

General comment: you should run 'checkpatch.pl --strict' script over the
patches. I came across several issues that will probably be flagged by it.

Gr. AvS

