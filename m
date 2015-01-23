Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:44093 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbbAWTkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 14:40:24 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] atmel: Remove open-coded and wrong strcasecmp
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421841127-8209-1-git-send-email-linux@rasmusvillemoes.dk>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Simon Kelley <simon@thekelleys.org.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20150123194023.B69BE141EF5@smtp.codeaurora.org> (sfid-20150123_204044_540009_8C432E5C)
Date: Fri, 23 Jan 2015 19:40:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The kernel's string library does in fact have strcasecmp, at least
> since ded220bd8f08 ("[STRING]: Move strcasecmp/strncasecmp to
> lib/string.c"). Moreover, this open-coded version is in fact wrong: If
> the strings only differ in their last character, a and b have already
> been incremented to point to the terminating NUL bytes, so they would
> wrongly be treated as equal.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Thanks, applied to wireless-drivers-next.git. I just remove the useless "net:
wireless:" from the title. People, PLEASE stop using that.

Kalle Valo
