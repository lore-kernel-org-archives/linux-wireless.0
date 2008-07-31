Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:15801 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYGaN75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 09:59:57 -0400
Received: by nf-out-0910.google.com with SMTP id d3so232979nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 06:59:55 -0700 (PDT)
To: akpm@linux-foundation.org
Subject: Re: [patch 4/4] wireless: replace __FUNCTION__ with __func__
Date: Thu, 31 Jul 2008 16:21:26 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	harvey.harrison@gmail.com
References: <200807301946.m6UJkMGK012997@imap1.linux-foundation.org>
In-Reply-To: <200807301946.m6UJkMGK012997@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807311621.26707.IvDoorn@gmail.com> (sfid-20080731_155959_376094_7E2193DE)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 July 2008, akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/net/wireless/rt2x00/rt2x00.h          |    4 ++--

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

