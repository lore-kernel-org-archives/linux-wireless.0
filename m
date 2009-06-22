Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24885 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZFVQBD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 12:01:03 -0400
Subject: Re: [PATCH] wireless: remove redundant tests on unsigned
From: Pavel Roskin <proski@gnu.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A3FA65D.5030107@gmail.com>
References: <4A3FA65D.5030107@gmail.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 12:01:04 -0400
Message-Id: <1245686464.26471.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-22 at 17:42 +0200, Roel Kluin wrote:
> bufsize and remainder are unsigned. When negative they are wrapped and caught by
> the other test.

For hermes.c:
Signed-off-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
