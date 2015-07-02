Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33005 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbbGBS0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 14:26:12 -0400
Received: by oiyy130 with SMTP id y130so62312192oiy.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 11:26:12 -0700 (PDT)
Date: Thu, 2 Jul 2015 13:25:36 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Wei Zhong <wzhong@google.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: update CA rules for 5600 - 5650 mHz
Message-ID: <20150702182536.GC40677@ubuntu-hedt> (sfid-20150702_202617_438550_36EDD429)
References: <1435857276-19209-1-git-send-email-wzhong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1435857276-19209-1-git-send-email-wzhong@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 02, 2015 at 10:14:36AM -0700, Wei Zhong wrote:
> Related regulation:
> http://www.ic.gc.ca/eic/site/smt-gst.nsf/eng/sf10971.html#s6.2.3
> 
> Frequency Bands 5470-5600 MHz and 5650-5725 MHz
> Until further notice, devices subject to this section [i.e. Wifi device
> supporting 5 GHz bands] shall not be capable of transmitting in the band
> 5600-5650 MHz. This restriction is for the protection of Environment
> Canada’s weather radars operating in this band.
> 
> Signed-off-by: Wei Zhong <wzhong@google.com>

That looks better, thanks. I'll leave some time for others to comment
before applying, but this looks okay to me.

Thanks,
Seth
