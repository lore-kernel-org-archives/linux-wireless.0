Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdF0Lcx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 07:32:53 -0400
Date: Tue, 27 Jun 2017 13:32:52 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2 3.18-stable] mac80211/wpa: use constant time memory
 comparison for MACs
Message-ID: <20170627113252.GJ10609@kroah.com> (sfid-20170627_133256_862159_F36DED7F)
References: <1497818656.2259.1.camel@sipsolutions.net>
 <20170619164406.23738-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170619164406.23738-1-Jason@zx2c4.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 19, 2017 at 06:44:06PM +0200, Jason A. Donenfeld wrote:
> Otherwise, we enable all sorts of forgeries via timing attack.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> This is for 3.18. Tested this, and it works as intended.

Thanks, now applied.

greg k-h
