Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751292AbdJSIyR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 04:54:17 -0400
Date: Thu, 19 Oct 2017 10:54:15 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: iwlegacy: Convert timers to use timer_setup()
Message-ID: <20171019085414.GB22113@redhat.com> (sfid-20171019_105441_480188_45B94656)
References: <20171016233744.GA101655@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171016233744.GA101655@beast>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 16, 2017 at 04:37:44PM -0700, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
