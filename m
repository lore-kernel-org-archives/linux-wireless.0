Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4365 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbYIMDD0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 23:03:26 -0400
Subject: Re: [PATCH] orinoco: Fix compile warnings
From: Pavel Roskin <proski@gnu.org>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221254898-10820-1-git-send-email-kilroyd@googlemail.com>
References: <1221254898-10820-1-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 23:03:23 -0400
Message-Id: <1221275003.5477.2.camel@dv> (sfid-20080913_050349_448750_B8AF1749)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-09-12 at 22:28 +0100, David Kilroy wrote:
> Use min_t to avoid warnings when the typesafe version is used.
> 
> Explicitly cast u64s to unsigned long long when being passed to printk.
> 
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>

Acked-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
