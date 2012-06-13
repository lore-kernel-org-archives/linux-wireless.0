Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56899 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2FMNuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 09:50:09 -0400
Date: Wed, 13 Jun 2012 08:50:07 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 0/9] brcm80211: smac: rework regulatory support
Message-ID: <20120613135007.GC3490@thinkpad-t410> (sfid-20120613_155014_294985_1177002B)
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
 <4FD860DD.4060700@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FD860DD.4060700@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2012 at 11:43:57AM +0200, Arend van Spriel wrote:
> On 06/05/2012 04:34 PM, Seth Forshee wrote:
> > brcmsmac has its own internal regulatory implementation which attempts
> > to enforce a Broadcom defined domain named X2. This code has no
> > integration with mac80211 regulatory other than supplying regulatory
> > hints, and thus each implementation operates independently of the other,
> > enforcing conflicting sets of rules.
> 
> Hi Seth,
> 
> This series looks fine. I have sent two small comment replies on it.
> Actually, only one reply is on the code change. I want to run some
> testing today/tomorrow and let you know the results.

Thanks! I'll wait for the test results before sending v3 patches.

