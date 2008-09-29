Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:48273 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYI2ORV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 10:17:21 -0400
Received: by nf-out-0910.google.com with SMTP id d3so657758nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 07:17:19 -0700 (PDT)
Message-ID: <48E0E36B.9060807@gmail.com> (sfid-20080929_161727_809195_E6BA3667)
Date: Mon, 29 Sep 2008 16:17:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Marc Pignat <marc.pignat@hevs.ch>
CC: mickflemm@gmail.com, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [RFC, PATCH] ath5k: compilation fix for ARM
References: <200809291607.33690.marc.pignat@hevs.ch>
In-Reply-To: <200809291607.33690.marc.pignat@hevs.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2008 04:07 PM, Marc Pignat wrote:
> ARM linux port does not handle udleay > 2000.
> 
> Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
> ---
> 
> Best regards
> 
> Marc
> 
> patch against 2.6.27-rc7

Thanks, but Nick already fixed that:
http://kerneltrap.org/mailarchive/linux-ath5k-devel/2008/9/17/3317654
