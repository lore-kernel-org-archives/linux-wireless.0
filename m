Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0053.outbound.protection.outlook.com ([104.47.40.53]:54272
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751241AbdH2Prd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 11:47:33 -0400
Date: Tue, 29 Aug 2017 18:47:21 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 15/27] qtnfmac: remove unused mac::status field
Message-ID: <20170829154720.7rdiufkq6ktu6ey3@bars> (sfid-20170829_174738_224027_5D01C496)
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-16-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825023024.10565-16-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 24, 2017 at 07:30:12PM -0700, igor.mitsyanko.os@quantenna.com wrote:
> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> It is no longer used.

If we come to the agreement on the previous patch,
then this field should be kept.

Regards,
Sergey
