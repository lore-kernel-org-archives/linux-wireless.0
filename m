Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:57972 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbAPSRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 13:17:14 -0500
Received: by mail-lb0-f180.google.com with SMTP id f15so10222832lbj.11
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 10:17:12 -0800 (PST)
Message-ID: <54B955A5.3090901@cogentembedded.com> (sfid-20150116_191729_470349_7257DE67)
Date: Fri, 16 Jan 2015 21:17:09 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Simon Kelley <simon@thekelleys.org.uk>,
	Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: atmel: Remove open-coded and wrong strcasecmp
References: <1421414907-26764-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1421414907-26764-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 01/16/2015 04:28 PM, Rasmus Villemoes wrote:

> The kernel's string library does in fact have strcasecmp, at least
> since ded220bd8f08. Moreover, this open-coded version is in fact

    Please also specify that commit's summary line in parens.

> wrong: If the strings only differ in their last character, a and b
> have already been incremented to point to the terminating nul bytes,

    NUL.

> so they would be treated as equal.

> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[...]

WBR, Sergei

