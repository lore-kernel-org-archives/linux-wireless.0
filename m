Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59146 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbeICNuz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 09:50:55 -0400
Message-ID: <1535967088.3437.25.camel@sipsolutions.net> (sfid-20180903_113139_608058_999E687B)
Subject: Re: [PATCH 09/28] mac80211: pass the TWT support bits in extended
 caps to the driver
From: Johannes Berg <johannes@sipsolutions.net>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Date: Mon, 03 Sep 2018 11:31:28 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB30126D281A5@HASMSX112.ger.corp.intel.com>
References: <20180831083130.15525-1-luca@coelho.fi>
         <20180831083130.15525-10-luca@coelho.fi>
         (sfid-20180831_103155_573128_7D703B85) <1535964771.3437.17.camel@sipsolutions.net>
         <0BA3FCBA62E2DC44AF3030971E174FB30126D281A5@HASMSX112.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-03 at 09:28 +0000, Grumbach, Emmanuel wrote:
> > 
> For managed mode, the driver will need to check the HE cap along with the
> extended capabilities to determine whether AP supports TWT or not.

Do you have any idea why it's there twice? Sounds like we should resolve
that in mac80211, rather than requiring the driver to check two
places...

johannes
