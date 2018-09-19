Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33780 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731391AbeISV7s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 17:59:48 -0400
Subject: Re: [PATCH 2/7] netlink: make validation_data const
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20180919120900.28708-1-johannes@sipsolutions.net>
 <20180919120900.28708-3-johannes@sipsolutions.net>
From: David Ahern <dsahern@gmail.com>
Message-ID: <3efeae51-8963-cb73-2fdd-457d2313b4c7@gmail.com> (sfid-20180919_182115_517031_929F461E)
Date: Wed, 19 Sep 2018 09:21:07 -0700
MIME-Version: 1.0
In-Reply-To: <20180919120900.28708-3-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/19/18 5:08 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The validation data is only used within the policy that
> should usually already be const, and isn't changed in any
> code that uses it. Therefore, make the validation_data
> pointer const.
> 
> While at it, remove the duplicate variable in the bitfield
> validation that I'd otherwise have to change to const.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/netlink.h | 2 +-
>  lib/nlattr.c          | 5 ++---
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
