Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0023.hostedemail.com ([216.40.44.23]:35173 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753358AbdJKKUm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 06:20:42 -0400
Message-ID: <1507717237.3552.48.camel@perches.com> (sfid-20171011_122152_624981_60A0FA31)
Subject: Re: [PATCH] rtl8xxxu: mark expected switch fall-throughs
From: Joe Perches <joe@perches.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 11 Oct 2017 03:20:37 -0700
In-Reply-To: <20171010193027.GA23108@embeddedor.com>
References: <20171010193027.GA23108@embeddedor.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-10 at 14:30 -0500, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

perhaps use Arnaldo's idea:

https://lkml.org/lkml/2017/2/9/845
https://lkml.org/lkml/2017/2/10/485
