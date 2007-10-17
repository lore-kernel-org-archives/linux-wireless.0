Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:64037 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761958AbXJQVgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 17:36:36 -0400
Received: by py-out-1112.google.com with SMTP id u77so4579355pyb
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2007 14:36:34 -0700 (PDT)
Message-ID: <43e72e890710171436s2e18a19ene70d3b058c835a96@mail.gmail.com> (sfid-20071017_223653_972339_CEFEBEDF)
Date: Wed, 17 Oct 2007 17:36:33 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k: avoid oops when ah_capabilities.cap_mode not set
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1192647780430-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192647780430-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/17/07, John W. Linville <linville@tuxdriver.com> wrote:
> ah_capabilities.cap_mode doesn't get set for some cards, causing the
> kernel to oops when these unknown/unsupported cards are inserted.
> Add some NULL checks to avoid this.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>

  Luis
