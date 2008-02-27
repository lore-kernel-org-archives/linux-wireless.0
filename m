Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20191 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYB0R51 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 12:57:27 -0500
Subject: Re: linux/wireless.h - missing section
From: Pavel Roskin <proski@gnu.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, jt@hpl.hp.com
In-Reply-To: <1ba2fa240802270940te95e776n4958ff6b9f5beb20@mail.gmail.com>
References: <1ba2fa240802270940te95e776n4958ff6b9f5beb20@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 12:57:25 -0500
Message-Id: <1204135045.12592.13.camel@dv> (sfid-20080227_175744_802699_08410DA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2008-02-27 at 19:40 +0200, Tomas Winkler wrote:
> Does anybody knows why this section is missing from in kernel linux/wireless.h

I remember it was decided to avoid significant improvement in Wireless
Extensions and concentrate on cfg80211.  This was supposed to be a part
of Wireless Extensions 21, but was removed in the final release.
Wireless Extensions 22 was a security fix.

-- 
Regards,
Pavel Roskin
