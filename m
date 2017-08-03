Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:45148 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdHCQ3J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 12:29:09 -0400
Date: Thu, 03 Aug 2017 09:29:08 -0700 (PDT)
Message-Id: <20170803.092908.1155197228589181228.davem@davemloft.net> (sfid-20170803_182927_623416_4ED8707B)
To: bhumirks@gmail.com
Cc: julia.lawall@lip6.fr, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, harish.patil@cavium.com,
        manish.chopra@cavium.com, Dept-GELinuxNICDev@cavium.com
Subject: Re: [PATCH 2/2] qlcnic: add const to bin_attribute structure
From: David Miller <davem@davemloft.net>
In-Reply-To: <1501696634-15765-3-git-send-email-bhumirks@gmail.com>
References: <1501696634-15765-1-git-send-email-bhumirks@gmail.com>
        <1501696634-15765-3-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bhumika Goyal <bhumirks@gmail.com>
Date: Wed,  2 Aug 2017 23:27:14 +0530

> Add const to bin_attribute structure as it is only passed to the
> functions sysfs_{remove/create}_bin_file. The corresponding
> arguments are of type const, so declare the structure to be const.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Applied.
