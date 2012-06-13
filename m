Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4667 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab2FMJqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 05:46:34 -0400
Message-ID: <4FD860DD.4060700@broadcom.com> (sfid-20120613_114637_684059_70000AD0)
Date: Wed, 13 Jun 2012 11:43:57 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 0/9] brcm80211: smac: rework regulatory support
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2012 04:34 PM, Seth Forshee wrote:
> brcmsmac has its own internal regulatory implementation which attempts
> to enforce a Broadcom defined domain named X2. This code has no
> integration with mac80211 regulatory other than supplying regulatory
> hints, and thus each implementation operates independently of the other,
> enforcing conflicting sets of rules.

Hi Seth,

This series looks fine. I have sent two small comment replies on it.
Actually, only one reply is on the code change. I want to run some
testing today/tomorrow and let you know the results.

Gr. AvS

