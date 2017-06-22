Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36159 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751883AbdFVDq7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 23:46:59 -0400
Date: Thu, 22 Jun 2017 13:46:45 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: cfg80211_ops
Message-ID: <20170622034645.GB16262@eros> (sfid-20170622_054712_126664_7C5BBB13)
References: <20170622000347.GA15458@eros>
 <a3105fed-a02b-cd0e-1f4a-e3f9a0b7dd1f@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a3105fed-a02b-cd0e-1f4a-e3f9a0b7dd1f@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 21, 2017 at 05:53:13PM -0700, Igor Mitsyanko wrote:
> On 06/21/2017 05:03 PM, Tobin C. Harding wrote:
> >
> >Hi,
> >
> >Is some one able to please confirm for me that the following
> >cfg80211_ops callbacks are enough to implement a minimal functioning
> >Wi-Fi driver. Assume that a virtual interface is added during driver
> >initialization.
> >
> >scan
> >add_key
> >get_key
> >del_key
> >sat_default_key
> >connect
> >disconnect
> >set_wiphy_params
> 
> Hi, is this for STA-only? I guess you also need
> mgmt_frame_register
> mgmt_tx

Thanks for the response Igor. Yes, infrastructure mode only.

> and you don't need *_key callbacks in case its fine to operate without
> encryption.

Cool, thank you.

Tobin
