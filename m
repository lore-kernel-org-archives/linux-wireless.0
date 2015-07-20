Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36293 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbbGTOOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 10:14:36 -0400
Received: by obnw1 with SMTP id w1so102111601obn.3
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2015 07:14:35 -0700 (PDT)
Date: Mon, 20 Jul 2015 09:13:24 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Wei Zhong <wzhong@google.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: update CA rules for 5600 - 5650 mHz
Message-ID: <20150720141324.GA41548@ubuntu-hedt> (sfid-20150720_161439_511321_65F3F710)
References: <1436202593-12701-1-git-send-email-wzhong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1436202593-12701-1-git-send-email-wzhong@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 06, 2015 at 10:09:53AM -0700, Wei Zhong wrote:
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

Applied. I went ahead and bumped the 5490-5590 MHz range back up to 5600
MHz as per the subsequent discussion on the first patch. Thanks!
