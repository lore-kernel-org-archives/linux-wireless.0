Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388762AbeGXWIa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 18:08:30 -0400
Date: Tue, 24 Jul 2018 14:00:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Joe Perches <joe@perches.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jonathan Cameron <jic23@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-iio@vger.kernel.org,
        linux-pm@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 1/4] treewide: convert ISO_8859-1 text comments to utf-8
Message-Id: <20180724140010.e24a9964fd340afe2d98a994@linux-foundation.org> (sfid-20180724_230028_916834_CD5C3CD5)
In-Reply-To: <20180724111600.4158975-1-arnd@arndb.de>
References: <20180724111600.4158975-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 24 Jul 2018 13:13:25 +0200 Arnd Bergmann <arnd@arndb.de> wrote:

> Almost all files in the kernel are either plain text or UTF-8
> encoded. A couple however are ISO_8859-1, usually just a few
> characters in a C comments, for historic reasons.
> 
> This converts them all to UTF-8 for consistency.

Was "consistency" the only rationale?  The discussion is now outside my
memory horizon but I thought there were other reasons.

Will we be getting a checkpatch rule to keep things this way?
