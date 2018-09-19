Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbeISIan (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 04:30:43 -0400
Date: Tue, 18 Sep 2018 19:54:56 -0700 (PDT)
Message-Id: <20180918.195456.1557976111284221132.davem@redhat.com> (sfid-20180919_045511_785462_577CCF59)
To: gregkh@linuxfoundation.org
Cc: sameo@linux.intel.com, netdev@vger.kernel.org,
        allen.pais@oracle.com, keescook@chromium.org, surenb@google.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] NFC fixes for 4.19-final
From: David Miller <davem@redhat.com>
In-Reply-To: <20180917135141.28328-1-gregkh@linuxfoundation.org>
References: <20180917135141.28328-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 17 Sep 2018 15:51:39 +0200

> For some reason, these two NFC patches fell through the cracks.  It
> looks like sometimes NFC patches go through the wireless tree, and
> other times, through the networking tree directly.
> 
> I don't care which way they go, but they should get merged through some
> way, or, I can take them in my device tree, but that feels a bit odd to
> me.

I'll take these directly, thanks Greg.
