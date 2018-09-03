Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:58784 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbeICNMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 09:12:10 -0400
Message-ID: <1535964771.3437.17.camel@sipsolutions.net> (sfid-20180903_105303_926045_95B8764C)
Subject: Re: [PATCH 09/28] mac80211: pass the TWT support bits in extended
 caps to the driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 03 Sep 2018 10:52:51 +0200
In-Reply-To: <20180831083130.15525-10-luca@coelho.fi> (sfid-20180831_103155_573128_7D703B85)
References: <20180831083130.15525-1-luca@coelho.fi>
         <20180831083130.15525-10-luca@coelho.fi>
         (sfid-20180831_103155_573128_7D703B85)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-08-31 at 11:31 +0300, Luca Coelho wrote:

> Since those bits are present in the HE Cap as well,
> we can set the capability bits in the Extended
> Capabilities IE based on what is advertised in the HE Cap IE.

It's not clear to me what this is trying to say, you don't seem to do
anything with the HE capabilities in the patch.

johannes
