Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934756AbcI2SVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Sep 2016 14:21:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE92D2E7846
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2016 20:21:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E020BAC23
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2016 20:21:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7FD7ABAC28
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2016 20:21:18 +0200 (CEST)
Date: Thu, 29 Sep 2016 20:21:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2016-09-29
Message-ID: <20160929182117.GA18734@salvia> (sfid-20160929_202211_557294_1CD4F0BC)
References: <87ponmve2v.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ponmve2v.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 29, 2016 at 07:57:28PM +0300, Kalle Valo wrote:
> Hi Dave,
> 
> this should be the last wireless-drivers-next pull request for 4.9, from
> now on only important bugfixes. Nothing really special stands out,
> iwlwifi being most active but other drivers also getting attention. More
> details in the signed tag. Please let me know if there are any problems.
> 
> Or actually I had one problem. While doing a test merge I noticed that
> net-next fails to compile for me, but I don't think this is anything
> wireless related:
> 
>   CC      net/netfilter/core.o
> net/netfilter/core.c: In function 'nf_set_hooks_head':
> net/netfilter/core.c:96:149: error: 'struct net_device' has no member named 'nf_hooks_ingress'

That's my problem, will be sending a pull request to fix this asap,
thanks.
