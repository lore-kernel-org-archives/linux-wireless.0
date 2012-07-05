Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49903 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GEQon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 12:44:43 -0400
Received: by pbbrp8 with SMTP id rp8so13031768pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 09:44:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20469.16960.475409.87512@gargle.gargle.HOWL>
References: <20469.16960.475409.87512@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 5 Jul 2012 09:44:22 -0700
Message-ID: <CAB=NE6ViKjoL9ViLzpsHzQujYi4eFcQYRfVy+aky7g7nZcpGiw@mail.gmail.com> (sfid-20120705_184446_983572_746C78AF)
Subject: Re: [PATCH] compat-wireless: Make target/compat branch check optional
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 5, 2012 at 12:29 AM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> The safety check to ensure that the target kernel and the
> local compat-wireless branch are the same can be adjusted a
> bit to allow users to generate stable releases from a temporary
> branch.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, applied and pushed, I also propagated this to the linux-3.5.y branch.

  Luis
