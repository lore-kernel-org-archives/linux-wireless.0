Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33915 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732340AbeGJXqL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 19:46:11 -0400
Received: by mail-pf0-f193.google.com with SMTP id e10-v6so17136927pfn.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2018 16:44:44 -0700 (PDT)
Date: Tue, 10 Jul 2018 16:44:41 -0700
From: Brian Norris <briannorris@chromium.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: devicetree@vger.kernel.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, andy.gross@linaro.org,
        niklas.cassel@linaro.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/6] dt: bindings: add bindings for msa memory region
Message-ID: <20180710234440.GB40352@ban.mtv.corp.google.com> (sfid-20180711_014531_970384_64ADE0C5)
References: <20180706090043.28363-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180706090043.28363-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 06, 2018 at 02:30:43PM +0530, Govind Singh wrote:
[snip]

You still don't quite have the threading right on this series. All the
other patches seem OK -- they have this in the header, which links them
to the cover letter:

In-Reply-To: <20180706085622.27945-1-govinds@codeaurora.org>
References: <20180706085622.27945-1-govinds@codeaurora.org>

But you seem to have missed that on this one patch for some reason.

Brian
