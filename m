Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48120 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2EKQtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 12:49:45 -0400
Received: by qadb17 with SMTP id b17so1453928qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2012 09:49:44 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1336733942.4310.21.camel@jlt3.sipsolutions.net>
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	<1336665952-24363-2-git-send-email-johannes@sipsolutions.net>
	<1336733942.4310.21.camel@jlt3.sipsolutions.net>
Date: Fri, 11 May 2012 18:49:44 +0200
Message-ID: <CA+icZUW6CCxntmmO22k0PDJLfA2cT7zaJRv6+5M5c9=etd5Sig@mail.gmail.com> (sfid-20120511_184949_083355_55D53D30)
Subject: Re: [PATCH 1/4 v2] iwlwifi: fix prints in iwl_rx_handle
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2012 at 12:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> The debug prints were wrong and buggy. The HW pointer wasn't printed
> correctly, it was mixed up with the pointer to the rxbuf.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> v2: make patch apply -- looks like some whitespace diff to upstream
> crept into our tree, thanks dileks.
>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
