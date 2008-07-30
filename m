Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:20777 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760079AbYG3WEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 18:04:07 -0400
Received: by rv-out-0506.google.com with SMTP id k40so232356rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 15:04:07 -0700 (PDT)
Message-ID: <1ba2fa240807301504j7fb86406hcbf85dceb645ad6@mail.gmail.com> (sfid-20080731_000419_022635_B593A9DA)
Date: Thu, 31 Jul 2008 01:04:06 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: akpm@linux-foundation.org
Subject: Re: [patch 4/4] wireless: replace __FUNCTION__ with __func__
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	harvey.harrison@gmail.com
In-Reply-To: <200807301946.m6UJkMGK012997@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200807301946.m6UJkMGK012997@imap1.linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 30, 2008 at 10:46 PM,  <akpm@linux-foundation.org> wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
>
> __FUNCTION__ is gcc-specific, use __func__
>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This patch conflicts (doing the same)  with the patch I've posted
chronologically before
http://marc.info/?l=linux-wireless&m=121659723529274&w=2
Tomas
